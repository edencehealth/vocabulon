# vocabulon

## usage

the container produces the following help text when started with the `-h` or `--help` arguments:

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