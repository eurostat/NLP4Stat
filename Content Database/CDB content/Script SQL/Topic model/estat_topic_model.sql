CREATE TABLE "ESTAT"."V1"."mod_topic_models" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar,
  "coherence_score" float,
  "tools" varchar,
  "date" datetime,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_results" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "model_id" integer,
  "topic_model" varchar,
  "position" integer,
  "probability" integer,
  "date_create" datetime,
  "date_modify" datetime,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_MODEL_RESULTS FOREIGN KEY ("model_id") REFERENCES "ESTAT"."V1"."mod_topic_models" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_tm_words_results" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "tm_results_id" bigint,
  "word" varchar,
  "probability" float,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_RESULTS_WORD FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_link_tm" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "link_id" bigint,
  "tm_results_id" bigint,
  "proportion" float,
  "position" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_TM FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_TM_LINK FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)
