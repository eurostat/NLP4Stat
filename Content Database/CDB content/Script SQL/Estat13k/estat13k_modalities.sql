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
