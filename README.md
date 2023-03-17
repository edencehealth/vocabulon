# vocabulon

VOCABULON loads vocabs for breakfast!

...robot breakfast ...and just CDM vocabs ...and just into PostgreSQL servers ...so watch out!

## usage

Behold: VOCABULON produces the following help text when started with the `-h` or `--help` arguments:

```
vocabulon is for creating vocab tables and populating them (over the network)
configuration is by envvar or command-line arguments

Usage: vocabulon [-h|--help] [options]

-h / --help   show this message
-d / --debug  print additional debugging messages

--pghost PGHOST              database server address to connect to (default: 127.0.0.1)
--pgport PGPORT              port number to connect to the database server on (default: 5432)
--pguser PGUSER              username to use when authenticating to the server (default: user)
--pgpassword PGPASSWORD      password to use when authenticating to the server (default: empty string)
--pgdatabase PGDATABASE      database name to access on the database server (default: user)
--schema SCHEMA              schema to place the vocab tables in (default: vocab)
--schema-owner SCHEMA_OWNER  optional owner to apply to created schemas and tables (default: )
--vocab-dir VOCAB_DIR        directory where vocab CSV files can be found (default: ./vocab)
--scratch-dir SCRATCH_DIR    directory where scratch files can be written (default: /work)
```

Calling forth VOCABULON's awesome power goes like this (assuming you have a directory called `vocab` with some CSV files in it):

```sh
docker run --rm --volume "$(pwd)/vocab" edence/vocabulon:v1 \
  --pghost db.example.com \
  --pguser calculon \
  --pgpassword all-my-circuits2 \
  --pgdatabase omopcdm
```

**If needed**, VOCABULON will create the `concept`, `concept_ancestor`, `concept_class`, `concept_relationship`, `concept_synonym`, `domain`, `drug_strength`, and `relationship` tables in the chosen schema (`vocab` by default). It will even create the schema if it's missing.

**Next**, VOCABULON will unrelentingly populate those tables with data from your puny-barely-a-challenge-at-all CSV files.
