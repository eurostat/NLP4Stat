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
  "infotype_id" integer, 
  PRIMARY KEY ("id"),
  CONSTRAINT FK_STATUS_RESOURCE FOREIGN KEY ("status_id") REFERENCES "ESTAT"."V1"."mod_status" ("id"),
  CONSTRAINT FK_INFOTYPE_RESOURCE FOREIGN KEY ("infotype_id") REFERENCES "ESTAT"."V1"."mod_infotype" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_resource_altlabel" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "lexical_type_id" varchar,
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