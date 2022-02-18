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




