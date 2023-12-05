CURL=curl -fsSL
DDL_URL="https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.4.1/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_ddl.sql"
FKY_URL="https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.4.1/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_constraints.sql"
IDX_URL="https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.4.1/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_indices.sql"
PKY_URL="https://raw.githubusercontent.com/OHDSI/CommonDataModel/v5.4.1/inst/ddl/5.4/postgresql/OMOPCDM_postgresql_5.4_primary_keys.sql"
.PHONY: all clean

all: ddl.sql fky.sql idx.sql pky.sql

clean:
	rm -vf ddl.sql fky.sql idx.sql pky.sql raw-ddl.sql raw-fky.sql raw-idx.sql raw-pky.sql

raw-ddl.sql:
	$(CURL) $(DDL_URL) >$@

raw-pky.sql:
	$(CURL) $(PKY_URL) >$@

raw-fky.sql:
	$(CURL) $(FKY_URL) >$@

raw-idx.sql:
	$(CURL) $(IDX_URL) >$@

ddl.sql: raw-ddl.sql Makefile
	perl \
	  -e 'my $$sql = do{local($$/);<>};' \
	  -e '$$sql =~ s/^\s*--.+?$$//gm;' \
	  -e '$$sql =~ s/CREATE TABLE \@cdmDatabaseSchema\.((?!COHORT|COHORT_DEFINITION|CONCEPT|CONCEPT_ANCESTOR|CONCEPT_CLASS|CONCEPT_RELATIONSHIP|CONCEPT_SYNONYM|DOMAIN|DRUG_STRENGTH|RELATIONSHIP|SOURCE_TO_CONCEPT_MAP|VOCABULARY)\w+)\s*\(.+?\);//gs;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema\.COHORT/\$$\{RESULTS_SCHEMA\}.COHORT/g;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema/\$$\{CDM_SCHEMA\}/g;' \
	  -e '$$sql =~ s/CREATE TABLE/CREATE TABLE IF NOT EXISTS/g;' \
	  -e '$$sql =~ s/^[\t\ ]+/  /gm;' \
	  -e '$$sql =~ s/\s+\);/\n);\n/gm;' \
	  -e '$$sql =~ s/\n{2,}/\n\n/g;' \
	  -e '$$sql =~ s/^\s+//;' \
	  -e '$$sql =~ s/\n+$$/\n/;' \
	  -e 'print STDOUT $$sql;' \
	  >$@ < $<
	rm $<

pky.sql: raw-pky.sql Makefile
	perl \
	  -e 'my $$sql = do{local($$/);<>};' \
	  -e '$$sql =~ s/^\s*--.+?$$//gm;' \
	  -e '$$sql =~ s/ALTER TABLE \@cdmDatabaseSchema\.((?!COHORT|COHORT_DEFINITION|CONCEPT|CONCEPT_ANCESTOR|CONCEPT_CLASS|CONCEPT_RELATIONSHIP|CONCEPT_SYNONYM|DOMAIN|DRUG_STRENGTH|RELATIONSHIP|SOURCE_TO_CONCEPT_MAP|VOCABULARY)\w+)\s+.+?;//gs;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema\.COHORT/\$$\{RESULTS_SCHEMA\}.COHORT/g;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema/\$$\{CDM_SCHEMA\}/g;' \
	  -e '$$sql =~ s/\n{2,}/\n\n/g;' \
	  -e '$$sql =~ s/^\s+//;' \
	  -e '$$sql =~ s/\n+$$/\n/;' \
	  -e 'print STDOUT $$sql;' \
	  >$@ < $<
	rm $<

fky.sql: raw-fky.sql Makefile
	perl \
	  -e 'my $$sql = do{local($$/);<>};' \
	  -e '$$sql =~ s/^\s*--.+?$$//gm;' \
	  -e '$$sql =~ s/ALTER TABLE \@cdmDatabaseSchema\.((?!COHORT|COHORT_DEFINITION|CONCEPT|CONCEPT_ANCESTOR|CONCEPT_CLASS|CONCEPT_RELATIONSHIP|CONCEPT_SYNONYM|DOMAIN|DRUG_STRENGTH|RELATIONSHIP|SOURCE_TO_CONCEPT_MAP|VOCABULARY)\w+)\s+.+?;//gs;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema\.COHORT/\$$\{RESULTS_SCHEMA\}.COHORT/g;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema/\$$\{CDM_SCHEMA\}/g;' \
	  -e '$$sql =~ s/CREATE TABLE/CREATE TABLE IF NOT EXISTS/g;' \
	  -e '$$sql =~ s/\n{2,}/\n\n/g;' \
	  -e '$$sql =~ s/^\s+//;' \
	  -e '$$sql =~ s/\n+$$/\n/;' \
	  -e 'print STDOUT $$sql;' \
	  >$@ < $<
	rm $<

idx.sql: raw-idx.sql Makefile
	perl \
	  -e 'my $$sql = do{local($$/);<>};' \
	  -e '$$sql =~ s/^\s*--.+?$$//gm;' \
	  -e '$$sql =~ s/^.+\@cdmDatabaseSchema\.((?!COHORT|COHORT_DEFINITION|CONCEPT|CONCEPT_ANCESTOR|CONCEPT_CLASS|CONCEPT_RELATIONSHIP|CONCEPT_SYNONYM|DOMAIN|DRUG_STRENGTH|RELATIONSHIP|SOURCE_TO_CONCEPT_MAP|VOCABULARY)\w+).+;\s*$$//gim;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema\.COHORT/\$$\{RESULTS_SCHEMA\}.COHORT/gi;' \
	  -e '$$sql =~ s/\@cdmDatabaseSchema/\$$\{CDM_SCHEMA\}/g;' \
	  -e '$$sql =~ s#/\*.+?\*/##gs;' \
	  -e '$$sql =~ s/\n{2,}/\n\n/g;' \
	  -e '$$sql =~ s/^\s+//;' \
	  -e '$$sql =~ s/\n+$$/\n/;' \
	  -e 'print STDOUT $$sql;' \
	  >$@ < $<
	rm $<
