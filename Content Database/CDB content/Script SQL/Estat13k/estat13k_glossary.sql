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