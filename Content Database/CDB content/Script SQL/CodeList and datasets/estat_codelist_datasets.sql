
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