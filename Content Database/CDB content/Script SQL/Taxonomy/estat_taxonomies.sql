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