CREATE TABLE "ESTAT"."V1"."mod_status" (
  "id" integer NOT NULL IDENTITY,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_infotype" (
  "id" integer NOT NULL IDENTITY ,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_lexical_type" (
  "id" integer NOT NULL IDENTITY,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_collection" (
  "id" integer NOT NULL IDENTITY ,
  "label_en" varchar NOT NULL,
  "label_fr" varchar NOT NULL,
  "label_de" varchar,
  "uri" varchar,
  "date_created" datetime, 
  "date_modified" datetime,
  "status_id" integer,
  "date_deprecated" datetime,
  "definition" long varchar,
  "editorial_note" long varchar,
  "change_note" long varchar,
  "scope_note" long varchar,
  "example" long varchar,
  "history_note" long varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_STATUS_COLLECTION FOREIGN KEY ("status_id") REFERENCES "ESTAT"."V1"."mod_status" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_resource" (
  "id" integer NOT NULL IDENTITY,
  "label_en" varchar NOT NULL,
  "label_fr" varchar,
  "label_de" varchar,
  "uri" varchar,
  "date_created" datetime, 
  "date_modified" datetime,
  "status_id" integer,
  "date_deprecated" datetime,
  "definition" long varchar,
  "editorial_note" long varchar,
  "change_note" long varchar,
  "scope_note" long varchar,
  "example" long varchar,
  "history_note" long varchar,
  "infotype_id" integer, 
  PRIMARY KEY ("id"),
  CONSTRAINT FK_STATUS_RESOURCE FOREIGN KEY ("status_id") REFERENCES "ESTAT"."V1"."mod_status" ("id"),
  CONSTRAINT FK_INFOTYPE_RESOURCE FOREIGN KEY ("infotype_id") REFERENCES "ESTAT"."V1"."mod_infotype" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_resource_altlabel" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "lexical_type_id" integer,
  "resource_id" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LABEL_TYPE FOREIGN KEY ("lexical_type_id") REFERENCES "ESTAT"."V1"."mod_lexical_type" ("id"),
  CONSTRAINT FK_RESOURCE_ALTLABEL FOREIGN KEY ("resource_id") REFERENCES "ESTAT"."V1"."dat_resource" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_collection_resource" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "collection_id" integer NOT NULL,
  "resource_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_COLLECTION_RESOURCE FOREIGN KEY ("collection_id") REFERENCES "ESTAT"."V1"."dat_collection" ("id"),
  CONSTRAINT FK_RESOURCE_COLLECTION FOREIGN KEY ("resource_id") REFERENCES "ESTAT"."V1"."dat_resource" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_link_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "title" varchar NOT NULL,
  "url" varchar NOT NULL,
  "resource_information_id" integer,
  "resource_type_id" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_INFO_LINK FOREIGN KEY ("resource_information_id") REFERENCES "ESTAT"."V1"."dat_resource" ("id"),
  CONSTRAINT FK_TYPE_LINK FOREIGN KEY ("resource_type_id") REFERENCES "ESTAT"."V1"."dat_resource" ("id")
)

/*************************************************************************************  Taxonomy  ***********************************************************************************/
CREATE TABLE "ESTAT"."V1"."mod_taxonomy" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar,
  "uri" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_srm_concept_type" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar,
  "uri" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_taxo_elmnt" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "taxo_id" integer,
  "label" varchar,
  "uri" varchar,
  "date_create" datetime,
  "status_id" integer,
  "date_deprecated" datetime,
  "definition" long varchar,
  "editorial_note" long varchar,
  "change_note" long varchar,
  "scope_note" long varchar,
  "example" long varchar,
  "history_note" long varchar,
  "lexical_unit_main" varchar,
  "srm_concept_type_id" integer,
  "notation" varchar,
  "top_level" smallint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TAXO_ELMNT FOREIGN KEY ("taxo_id") REFERENCES "ESTAT"."V1"."mod_taxonomy" ("id"),
  CONSTRAINT FK_ELMNT_STATUS FOREIGN KEY ("status_id") REFERENCES "ESTAT"."V1"."mod_status" ("id"),
  CONSTRAINT FK_ELMNT_SRM_CONCEPT FOREIGN KEY ("srm_concept_type_id") REFERENCES "ESTAT"."V1"."mod_srm_concept_type" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_taxo_relations" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "parent_id" bigint,
  "child_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ELMNT_PARENT FOREIGN KEY ("parent_id") REFERENCES "ESTAT"."V1"."dat_taxo_elmnt" ("id"),
  CONSTRAINT FK_ELMNT_CHILD FOREIGN KEY ("child_id") REFERENCES "ESTAT"."V1"."dat_taxo_elmnt" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_link_info_taxonomy" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "link_id" bigint,
  "taxo_elmnt_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TAXOELMNT_LINK FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_LINK_TAXOELMNT FOREIGN KEY ("taxo_elmnt_id") REFERENCES "ESTAT"."V1"."dat_taxo_elmnt" ("id")
)

/*********************************************************************************** Terminology *************************************************************************************************/
CREATE TABLE "ESTAT"."V1"."mod_table" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar,
  "uri" varchar,
  "table_name" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_terminology" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "uri" varchar,
  "label_en" varchar,
  "label_fr" varchar,
  "label_de" varchar,
  "lemm_en" varchar,
  "lemm_fr" varchar,
  "lemm_de" varchar,
  "lexical_unit_main" varchar,
  "definition" long varchar,
  "editorial_note" long varchar,
  "change_note" long varchar,
  "scope_note" long varchar,
  "example" long varchar,
  "history_note" long varchar,
  "status_id" integer,
  "date_deprecated" datetime,
  "date_create" datetime,
  "date_modify" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TERMINO_STATUS FOREIGN KEY ("status_id") REFERENCES "ESTAT"."V1"."mod_status" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_variant" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "terminology_id" bigint,
  "label" varchar,
  "lemm" varchar,
  "lexical_unit_main" varchar,
  "date_create" datetime,
  "date_modify" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TERMINO_VARIANT FOREIGN KEY ("terminology_id") REFERENCES "ESTAT"."V1"."dat_terminology" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_terminology_relation" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "terminology_id" bigint,
  "table_id" integer,
  "table_elmnt_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TERMINO_REL FOREIGN KEY ("terminology_id") REFERENCES "ESTAT"."V1"."dat_terminology" ("id"),
  CONSTRAINT FK_TERMINO_TABLE FOREIGN KEY ("table_id") REFERENCES "ESTAT"."V1"."mod_table" ("id")
)


CREATE TABLE "ESTAT"."V1"."dat_taxo_termino" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "taxo_elmnt_id" bigint,
  "terminology_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TAXO_TERMINO FOREIGN KEY ("taxo_elmnt_id") REFERENCES "ESTAT"."V1"."dat_taxo_elmnt" ("id"),
  CONSTRAINT FK_TERMINO_TAXO FOREIGN KEY ("terminology_id") REFERENCES "ESTAT"."V1"."dat_terminology" ("id")
)


CREATE TABLE "ESTAT"."V1"."dat_annotation" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "terminology_id" bigint,
  "position" integer,
  "frequence" integer,
  "date_create" datetime,
  "confidence" float,
  "annotation_tool" varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TERMINO_ANNOTATION FOREIGN KEY ("terminology_id") REFERENCES "ESTAT"."V1"."dat_terminology" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_annotation_link" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "annotation_id" bigint,
  "document_id" integer,
  "column_name" varchar,
  "document_elmnt_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ANNOTATION_LINK FOREIGN KEY ("annotation_id") REFERENCES "ESTAT"."V1"."dat_annotation" ("id"),
  CONSTRAINT FK_ANNOTATION_TABLE FOREIGN KEY ("document_id") REFERENCES "ESTAT"."V1"."mod_table" ("id")
)

/*********************************************************************************** SE/OCDE Glossary ********************************************************************************************/
CREATE TABLE "ESTAT"."V1"."dat_glossary" (
  "id" bigint NOT NULL,
  "definition" long varchar NOT NULL,
  "redirection" smallint NOT NULL DEFAULT 0,
  "original_title" varchar,
  "homepage" smallint NOT NULL DEFAULT 0,
  "last_update" datetime DEFAULT NULL,
  "editorial_note" long varchar,
  "change_note" long varchar,
  "scope_note" long varchar,
  "example" long varchar,
  "history_note" long varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_GLOSSARY FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_further_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_FURTHER_INFO FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_FURTHER_INFO FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_related_concepts" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_RELATED_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_RELATED_CONCEPTS FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_sources" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_SOURCES_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_SOURCES_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_statistical_data" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_STAT_DATA_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_STAT_DATA_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_redirections" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_REDIRECTION_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_REDIRECTION_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

/******************************************************************************* Articles ****************************************************************************************/
CREATE TABLE "ESTAT"."V1"."mod_article_division" (
  "id" integer NOT NULL,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "context" long varchar,
  "data_sources" long varchar,
  "last_update" datetime,
  "background_article" smallint NOT NULL,
  "homepage" smallint NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_ARTICLE FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article_paragraph" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "article_id" bigint NOT NULL,
  "title" varchar,
  "content" long varchar,
  "abstract" smallint NOT NULL DEFAULT 0,
  "alert" smallint NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ARTICLE_PARAGRAPH FOREIGN KEY ("article_id") REFERENCES "ESTAT"."V1"."dat_article" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_paragraph_figure" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "paragraph_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_PARAGRAPH_FIGURE FOREIGN KEY ("paragraph_id") REFERENCES "ESTAT"."V1"."dat_article_paragraph" ("id"),
  CONSTRAINT FK_LINK_FIGURE FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article_shared_link" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "article_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  "article_division_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_SHARED_LINKS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_ARTICLE_SHARED_LINKS FOREIGN KEY ("article_id") REFERENCES "ESTAT"."V1"."dat_article" ("id"),
  CONSTRAINT FK_ARTICLE_DIVISION_LINKS FOREIGN KEY ("article_division_id") REFERENCES "ESTAT"."V1"."mod_article_division" ("id")
)

/***************************************************************************************** News/ Exp Statistics ******************************************************************/
CREATE TABLE "ESTAT"."V1"."dat_exp_statistics" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "content" long varchar,
  "methodology" long varchar,
  "statistics" long varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_EXP_STAT_LINKINFO FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_exp_stat_links" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "exp_stat_id" bigint,
  "link_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_EXPSTAT_LINK FOREIGN KEY ("exp_stat_id") REFERENCES "ESTAT"."V1"."dat_exp_statistics" ("id"),
  CONSTRAINT FK_LINK_EXPSTAT FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_news" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "content" long varchar,
  "publication_date" datetime,
  "euro_indicators" smallint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_NEWS_LINKINFO FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_news_links" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "news_id" bigint,
  "link_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_NEWS_LINK FOREIGN KEY ("news_id") REFERENCES "ESTAT"."V1"."dat_estat_news" ("id"),
  CONSTRAINT FK_LINK_NEWS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

/***************************************************************************************** Estat Glossary ************************************************************************/
CREATE TABLE "ESTAT"."V1"."mod_ramon_category" (
  "id" integer NOT NULL IDENTITY (START WITH 0),
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_concept_type" (
  "id" integer NOT NULL,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_measurement_unit" (
  "id" integer NOT NULL,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_statistical_unit" (
  "id" integer NOT NULL IDENTITY,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_glossary" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "order_id" integer NOT NULL,
  "code_id" integer NOT NULL,
  "term" varchar NOT NULL,
  "ramon_cat_id" integer NOT NULL,
  "concept_type_id" integer NOT NULL, 
  "definition" long varchar,
  "context" long varchar,
  "remark" long varchar,
  "date_create" datetime,
  "date_update" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_RAMON_CAT FOREIGN KEY ("ramon_cat_id") REFERENCES "ESTAT"."V1"."mod_ramon_category" ("id"),
  CONSTRAINT FK_CONCEPT_TYPE FOREIGN KEY ("concept_type_id") REFERENCES "ESTAT"."V1"."mod_concept_type" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estatg_stat_unit" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "estat_glossary_id" bigint NOT NULL,
  "stat_unit_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_STAT_UNIT FOREIGN KEY ("estat_glossary_id") REFERENCES "ESTAT"."V1"."dat_estat_glossary" ("id"),
  CONSTRAINT FK_STAT_UNIT FOREIGN KEY ("stat_unit_id") REFERENCES "ESTAT"."V1"."mod_statistical_unit" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estatg_measurement_unit" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "estat_glossary_id" bigint NOT NULL,
  "measurement_unit_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_MEASUREMENT_UNIT FOREIGN KEY ("estat_glossary_id") REFERENCES "ESTAT"."V1"."dat_estat_glossary" ("id"),
  CONSTRAINT FK_MEASUREMENT_UNIT FOREIGN KEY ("measurement_unit_id") REFERENCES "ESTAT"."V1"."mod_measurement_unit" ("id")
)

/******************************************************************************************************* CodeList & Datasets *******************************************************************************/
CREATE TABLE "ESTAT"."V1"."dat_reference_metadata" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "last_update" datetime,
  "data_description" long varchar,
  "classification_system" long varchar,
  "coverage" long varchar,
  "stat_concept" long varchar,
  "stat_unit" varchar,
  "stat_population" varchar,
  "reference_area" varchar,
  "coverage_time" varchar,
  "base_period" varchar,
  "measure_unit" varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_METADATA_LINKINFO FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_metadata_links" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "ref_metadata_id" integer,
  "link_id" bigint,
  "metadata" smallint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_METALINK_METADATA FOREIGN KEY ("ref_metadata_id") REFERENCES "ESTAT"."V1"."dat_reference_metadata" ("id"),
  CONSTRAINT FK_METALINK_LINK FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)


CREATE TABLE "ESTAT"."V1"."mod_code_list" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "abbreviation" varchar,
  "full_title" varchar,
  "taxo_elmnt_id" bigint,
  "ref_metadata_id" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_CODE_METADATA FOREIGN KEY ("ref_metadata_id") REFERENCES "ESTAT"."V1"."dat_reference_metadata" ("id"),
  CONSTRAINT FK_CODE_TAXO FOREIGN KEY ("taxo_elmnt_id") REFERENCES "ESTAT"."V1"."dat_taxo_elmnt" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_code_dico" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "code" varchar NOT NULL,
  "label" varchar NOT NULL,
  "code_list_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_CODE_DICO FOREIGN KEY ("dico_id") REFERENCES "ESTAT"."V1"."mod_code_list" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_dataset" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_code_dataset" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "code_id" bigint NOT NULL,
  "dataset_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_CODE_DATASETS FOREIGN KEY ("code_id") REFERENCES "ESTAT"."V1"."dat_code_dico" ("id"),
  CONSTRAINT FK_DATASETS_CODE FOREIGN KEY ("dataset_id") REFERENCES "ESTAT"."V1"."dat_dataset" ("id")
)

/****************************************************************** Topic Model ****************************************************************************************/
CREATE TABLE "ESTAT"."V1"."mod_topic_models" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar,
  "coherence_score" float,
  "tools" varchar,
  "date" datetime,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_results" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "model_id" integer,
  "topic_model" varchar,
  "position" integer,
  "probability" integer,
  "date_create" datetime,
  "date_modify" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_MODEL_RESULTS FOREIGN KEY ("model_id") REFERENCES "ESTAT"."V1"."mod_topic_models" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_words_results" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "tm_results_id" bigint,
  "word" varchar,
  "probability" float,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_RESULTS_WORD FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_link_tm" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "link_id" bigint,
  "tm_results_id" bigint,
  "proportion" float,
  "position" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_TM FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_TM_LINK FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)