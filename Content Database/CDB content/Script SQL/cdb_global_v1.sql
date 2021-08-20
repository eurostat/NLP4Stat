CREATE TABLE "ESTAT"."V1"."mod_resource_information" (
  "id" integer NOT NULL IDENTITY (START WITH 0),
  "label" varchar NOT NULL,
  "uri" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_resource_type" (
  "id" integer NOT NULL IDENTITY (START WITH 0),
  "uri" varchar,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_link_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "title" varchar NOT NULL,
  "url" varchar NOT NULL,
  "resource_information_id" integer,
  "resource_type_id" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_INFO_LINK FOREIGN KEY ("resource_information_id") REFERENCES "ESTAT"."V1"."mod_resource_information" ("id"),
  CONSTRAINT FK_TYPE_LINK FOREIGN KEY ("resource_type_id") REFERENCES "ESTAT"."V1"."mod_resource_type" ("id")
)

/* SE Glossary */

CREATE TABLE "ESTAT"."V1"."dat_glossary" (
  "id" bigint NOT NULL,
  "definition" long varchar NOT NULL,
  "redirection" smallint NOT NULL DEFAULT 0,
  "original_title" varchar,
  "homepage" smallint NOT NULL DEFAULT 0,
  "last_update" datetime DEFAULT NULL,
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

/* SE Articles */

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

/* Estat Glossary*/

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

/* Dictionnary & Datasets*/
CREATE TABLE "ESTAT"."V1"."mod_dictionnary" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_code_dico" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "code" varchar NOT NULL,
  "label" varchar NOT NULL,
  "dico_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_CODE_DICO FOREIGN KEY ("dico_id") REFERENCES "ESTAT"."V1"."mod_dictionnary" ("id")
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