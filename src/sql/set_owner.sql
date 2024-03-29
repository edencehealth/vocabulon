ALTER TABLE ${CDM_SCHEMA}.CONCEPT OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.CONCEPT_ANCESTOR OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.CONCEPT_CLASS OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.CONCEPT_RELATIONSHIP OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.CONCEPT_SYNONYM OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.DOMAIN OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.DRUG_STRENGTH OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.RELATIONSHIP OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.SOURCE_TO_CONCEPT_MAP OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${CDM_SCHEMA}.VOCABULARY OWNER to ${CDM_SCHEMA_OWNER};
ALTER TABLE ${RESULTS_SCHEMA}.COHORT OWNER to ${RESULTS_SCHEMA_OWNER};
ALTER TABLE ${RESULTS_SCHEMA}.COHORT_DEFINITION OWNER to ${RESULTS_SCHEMA_OWNER};

ALTER SCHEMA ${CDM_SCHEMA} OWNER to ${CDM_SCHEMA_OWNER};
ALTER SCHEMA ${RESULTS_SCHEMA} OWNER to ${RESULTS_SCHEMA_OWNER};
