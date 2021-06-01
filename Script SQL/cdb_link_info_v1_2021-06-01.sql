CREATE TABLE "ESTAT"."V1"."mod_resource_information" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "url" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_resource_type" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
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