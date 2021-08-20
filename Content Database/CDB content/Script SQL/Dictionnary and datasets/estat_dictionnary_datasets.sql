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