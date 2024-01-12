#!/bin/sh
# shellcheck disable=SC3049
# bug report open: https://github.com/koalaman/shellcheck/issues/2715
set -eu
SELF=$(basename "$0" ".sh")
VERSION="${GITHUB_TAG:-}/${COMMIT_SHA:-}"

# https://www.postgresql.org/docs/current/libpq-envars.html
export \
  PGHOST="${PGHOST:-127.0.0.1}" \
  PGPORT="${PGPORT:-5432}" \
  PGUSER="${PGUSER:-user}" \
  PGPASSWORD="${PGPASSWORD:-}" \
  CDM_SCHEMA="${CDM_SCHEMA:-omopcdm}" \
  CDM_SCHEMA_OWNER="${CDM_SCHEMA_OWNER:-}" \
  KEY_IDX="${KEY_IDX:-1}" \
  RESULTS_SCHEMA="${RESULTS_SCHEMA:-results}" \
  RESULTS_SCHEMA_OWNER="${RESULTS_SCHEMA_OWNER:-}" \
;

# this has to come after the previous export
export \
  PGDATABASE="${PGDATABASE:-$PGUSER}" \
;

VOCAB_DIR="${VOCAB_DIR:-/vocab}" # no trailing slash
SCRATCH_DIR="${SCRATCH_DIR:-$(pwd)}" # override this if CWD isn't writeable (for tmp files)
IMPORT_DIR=$(dirname "$0")
SQL_DIR="${IMPORT_DIR}/sql"

usage() {
  exception="${1:-}"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "$SELF is for creating vocab tables and populating them (over the network)" \
    "configuration is by envvar or command-line arguments" \
    "" \
    "Usage: $SELF [-h|--help] [options]" \
    "" \
    "-h / --help     show this message" \
    "-v / --version  print the version number and exit" \
    "-d / --debug    print additional debugging messages" \
    "" \
    "--pghost PGHOST              database server address to connect to (default: $PGHOST)" \
    "--pgport PGPORT              port number to connect to the database server on (default: $PGPORT)" \
    "--pguser PGUSER              username to use when authenticating to the server (default: $PGUSER)" \
    "--pgpassword PGPASSWORD      password to use when authenticating to the server (default: empty string)" \
    "--pgdatabase PGDATABASE      database name to access on the database server (default: $PGDATABASE)" \
    "" \
    "--key-idx KEY_IDX            enable setting primary keys, foreign keys, indexes, and constraints" \
    "                             (default: TRUE)" \
    "" \
    "--cdm-schema CDM_SCHEMA                      schema to place the vocab tables in" \
    "                                             (default: $CDM_SCHEMA)" \
    "--cdm-schema-owner CDM_SCHEMA_OWNER          optional owner to apply to created" \
    "                                             schemas and tables" \
    "                                             (default: $CDM_SCHEMA_OWNER)" \
    "--results-schema RESULTS_SCHEMA              schema to place the vocab tables in" \
    "                                             (default: $RESULTS_SCHEMA)" \
    "--results-schema-owner RESULTS_SCHEMA_OWNER  optional owner to apply to created"\
    "                                             schemas and tables"\
    "                                             (default: $RESULTS_SCHEMA_OWNER)" \
    "" \
    "--vocab-dir VOCAB_DIR        directory where vocab CSV files can be found (default: $VOCAB_DIR)" \
    "--scratch-dir SCRATCH_DIR    directory where scratch files can be written (default: $SCRATCH_DIR)" \
    "" # no trailing slash

  [ -n "$exception" ] && exit 1
  exit 0
}

log() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

die() {
  log "FATAL:" "$@"
  exit 1
}

psql_cmd() {
  psql -v ON_ERROR_STOP=1 -q -At "$@"
}

parse_bool() {
  printf '%s' "$*" | grep -qiE '(1|true|yes|y|enable)'
}

make_txn() {
  txn_file=$(umask 0177; mktemp "${SCRATCH_DIR}/${SELF}.XXXXXX")
  echo "START TRANSACTION;" >"$txn_file"
  echo "$txn_file"
}

apply_txn() {
  # runs the given sql temp file then removes it
  txn_file="${1:?argument required}"
  echo "COMMIT;" >>"$txn"
  psql_cmd -f "$txn_file" || kill -s SIGUSR2 $$
  rm -- "$txn_file"
}

main() {

  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -v|--version)
        echo "$SELF $VERSION"
        exit
        ;;

      -d|--debug)
        set -x
        ;;

      --pghost)
        shift || die "--pghost requires an argument"
        PGHOST="$1"
        ;;

      --pgport)
        shift || die "--pgport requires an argument"
        PGPORT="$1"
        ;;

      --pguser)
        shift || die "--pguser requires an argument"
        PGUSER="$1"
        ;;

      --pgpassword)
        shift || die "--pgpassword requires an argument"
        PGPASSWORD="$1"
        ;;

      --pgdatabase)
        shift || die "--pgdatabase requires an argument"
        PGDATABASE="$1"
        ;;

      --cdm-schema)
        shift || die "--cdm-schema requires an argument"
        CDM_SCHEMA="$1"
        ;;

      --cdm-schema-owner)
        shift || die "--cdm-schema-owner requires an argument"
        CDM_SCHEMA_OWNER="$1"
        ;;

      --key-idx)
        shift || die "--key-idx requires an argument (boolean style)"
        KEY_IDX=$(parse_bool "$1")
        ;;

      --results-schema)
        shift || die "--results-schema requires an argument"
        RESULTS_SCHEMA="$1"
        ;;

      --results-schema-owner)
        shift || die "--results-schema-owner requires an argument"
        RESULTS_SCHEMA_OWNER="$1"
        ;;

      --vocab-dir)
        shift || die "--vocab-dir requires an argument"
        VOCAB_DIR="$1"
        ;;

      --scratch-dir)
        shift || die "--scratch-dir requires an argument"
        SCRATCH_DIR="$1"
        ;;

      --)
        shift || true
        break
        ;;

      *)
        usage "Unknown argument \"${arg}\""
        ;;
    esac
    shift || break
  done

  log "$VERSION starting as $(id) in $(pwd); running config:"
  printf '  %s="%s"\n' \
    PGHOST "$PGHOST" \
    PGPORT "$PGPORT" \
    PGUSER "$PGUSER" \
    PGPASSWORD "--REDACTED--" \
    PGDATABASE "$PGDATABASE" \
    CDM_SCHEMA "$CDM_SCHEMA" \
    CDM_SCHEMA_OWNER "$CDM_SCHEMA_OWNER" \
    RESULTS_SCHEMA "$RESULTS_SCHEMA" \
    RESULTS_SCHEMA_OWNER "$RESULTS_SCHEMA_OWNER" \
    SCRATCH_DIR "$SCRATCH_DIR" \
    VOCAB_DIR "$VOCAB_DIR" \
  >&2

  txn=$(make_txn)
  envsubst <"${SQL_DIR}/schemas.sql" >>"$txn"
  envsubst <"${SQL_DIR}/ddl.sql" >>"$txn"
  if [ -n "$CDM_SCHEMA_OWNER" ] && [ -n "$RESULTS_SCHEMA_OWNER" ] ; then
    log "including owner-setting commands " \
      "(cdm: ${CDM_SCHEMA_OWNER}; results: ${RESULTS_SCHEMA_OWNER})"
    envsubst <"${SQL_DIR}/set_owner.sql" >>"$txn"
  fi
  envsubst <"${SQL_DIR}/get_empty_tables.sql" >>"$txn"

  # prep some subshell IPC
  trap -- 'die "psql exited $?"' USR2
  load_count=0; trap -- 'load_count=$(( load_count + 1 )); wait ||:' USR1

  log "transaction built, sending to server"
  (
    apply_txn "$txn" | while read -r table; do
      # the transaction returns a list of empty tables that need vocab data
      capital_table=$(printf '%s' "$table" | tr '[:lower:]' '[:upper:]')
      src="${VOCAB_DIR}/${table##*.}.csv" # table minus the "vocab."
      if ! [ -f "$src" ]; then
        src="${VOCAB_DIR}/${capital_table##*.}.csv" # TABLE minus the "vocab."
      fi
      log "loading local ${src} into ${table}"
      psql_cmd -c "\copy ${table} FROM '${src}' WITH DELIMITER E'\t' CSV HEADER QUOTE E'\b'"
      kill -s SIGUSR1 $$  # increment i in the parent
    done
  ) &
  wait || :

  if [ -n "$ENABLE_KEY_IDX" ]; then
    # set primary keys, foreign keys, indexes, and constraints
    txn=$(make_txn)
    log "adding primary keys to transaction"
    envsubst <"${SQL_DIR}/pky.sql" >>"$txn"

    log "adding foreign keys to transaction"
    envsubst <"${SQL_DIR}/fky.sql" >>"$txn"

    log "adding indexes & constraints to transaction"
    envsubst <"${SQL_DIR}/idx.sql" >>"$txn"

    log "sending transaction to apply keys, indexes, and constraints"
    (
      apply_txn "$txn"
    ) &
    wait || :
  fi

  if [ "$load_count" = "0" ]; then
    log "no vocab tables are empty"
  else
    log "populated ${load_count} table(s)"
  fi

  log "done"
}

main "$@"; exit
