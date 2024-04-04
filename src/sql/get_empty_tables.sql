CREATE TEMP TABLE IF NOT EXISTS empty_tables(
  name VARCHAR(255) NULL
);

insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.concept_ancestor) THEN '${CDM_SCHEMA}.concept_ancestor' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.concept_class) THEN '${CDM_SCHEMA}.concept_class' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.concept_relationship) THEN '${CDM_SCHEMA}.concept_relationship' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.concept_synonym) THEN '${CDM_SCHEMA}.concept_synonym' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.concept) THEN '${CDM_SCHEMA}.concept' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.domain) THEN '${CDM_SCHEMA}.domain' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.drug_strength) THEN '${CDM_SCHEMA}.drug_strength' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.relationship) THEN '${CDM_SCHEMA}.relationship' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.source_to_concept_map) THEN '${CDM_SCHEMA}.source_to_concept_map' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${CDM_SCHEMA}.vocabulary) THEN '${CDM_SCHEMA}.vocabulary' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${RESULTS_SCHEMA}.cohort_definition) THEN '${RESULTS_SCHEMA}.cohort_definition' ELSE NULL END);
insert into empty_tables (select CASE WHEN NOT EXISTS (select * from ${RESULTS_SCHEMA}.cohort) THEN '${RESULTS_SCHEMA}.cohort' ELSE NULL END);

select name from empty_tables WHERE name is NOT NULL;
