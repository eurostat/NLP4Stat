CREATE TABLE "ESTAT"."V1"."mod_topic_models" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "coherence_score" float,
  "tools" varchar,
  "date_create" datetime,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_results" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "model_id" integer NOT NULL,
  "topic_label" varchar,
  "position" integer,
  "probability" float,
  "date_create" datetime,
  "date_modify" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_MODEL_RESULTS FOREIGN KEY ("model_id") REFERENCES "ESTAT"."V1"."mod_topic_models" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_results_words" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "tm_results_id" bigint NOT NULL,
  "word" varchar,
  "probability" float,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_TM_RESULTS_WORDS FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_concept_tm" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "tm_results_id" bigint NOT NULL,
  "word" varchar,
  "proportion" float,
  "position" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_CONCEPT_TM_RESULTS FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id"),
  CONSTRAINT FK_TM_RESULTS_CONCEPT FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)