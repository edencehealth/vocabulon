CREATE TEMP TABLE IF NOT EXISTS empty_tables(
  name VARCHAR(255) NULL
);

insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.concept) THEN '${SCHEMA}.concept' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.concept_ancestor) THEN '${SCHEMA}.concept_ancestor' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.concept_class) THEN '${SCHEMA}.concept_class' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.concept_relationship) THEN '${SCHEMA}.concept_relationship' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.concept_synonym) THEN '${SCHEMA}.concept_synonym' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.domain) THEN '${SCHEMA}.domain' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.drug_strength) THEN '${SCHEMA}.drug_strength' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${SCHEMA}.relationship) THEN '${SCHEMA}.relationship' ELSE NULL END);

select name from empty_tables WHERE name is NOT NULL;
