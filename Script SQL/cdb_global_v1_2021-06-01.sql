CREATE TABLE "ESTAT"."V1"."mod_resource_information" (
  "id" integer NOT NULL IDENTITY (START WITH 0),
  "label" varchar NOT NULL,
  "url" varchar,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."mod_resource_type" (
  "id" integer NOT NULL IDENTITY (START WITH 0),
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

/* Glossary */

CREATE TABLE "ESTAT"."V1"."dat_glossary" (
  "id" bigint NOT NULL,
  "definition" long varchar NOT NULL,
  "redirection" smallint NOT NULL DEFAULT 0,
  "original_title" varchar,
  "homepage" smallint NOT NULL DEFAULT 0,
  "last_update" datetime DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_GLOSSARY FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_further_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_FURTHER_INFO FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_FURTHER_INFO FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_related_concepts" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_RELATED_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_RELATED_CONCEPTS FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_sources" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_SOURCES_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_SOURCES_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_statistical_data" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_STAT_DATA_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_STAT_DATA_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_redirections" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "glossary_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_REDIRECTION_GLOSSARY FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_GLOSSARY_REDIRECTION_GLOSSARY FOREIGN KEY ("glossary_id") REFERENCES "ESTAT"."V1"."dat_glossary" ("id")
)

/* Article */

CREATE TABLE "ESTAT"."V1"."mod_article_division" (
  "id" integer NOT NULL,
  "label" varchar NOT NULL,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "context" long varchar,
  "data_sources" long varchar,
  "last_update" datetime,
  "background_article" smallint NOT NULL,
  "homepage" smallint NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_ARTICLE FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article_paragraph" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "article_id" bigint NOT NULL,
  "title" varchar,
  "content" long varchar,
  "abstract" smallint NOT NULL DEFAULT 0,
  "alert" smallint NOT NULL DEFAULT 0,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ARTICLE_PARAGRAPH FOREIGN KEY ("article_id") REFERENCES "ESTAT"."V1"."dat_article" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_paragraph_figure" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "paragraph_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_PARAGRAPH_FIGURE FOREIGN KEY ("paragraph_id") REFERENCES "ESTAT"."V1"."dat_article_paragraph" ("id"),
  CONSTRAINT FK_LINK_FIGURE FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_article_shared_link" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "article_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  "article_division_id" integer NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_SHARED_LINKS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_ARTICLE_SHARED_LINKS FOREIGN KEY ("article_id") REFERENCES "ESTAT"."V1"."dat_article" ("id"),
  CONSTRAINT FK_ARTICLE_DIVISION_LINKS FOREIGN KEY ("article_division_id") REFERENCES "ESTAT"."V1"."mod_article_division" ("id")
)

/* Topic Model*/

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

CREATE TABLE "ESTAT"."V1"."dat_link_tm" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "link_id" bigint NOT NULL,
  "tm_results_id" bigint NOT NULL,
  "word" varchar,
  "proportion" float,
  "position" integer,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_TM_RESULTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_TM_RESULTS_LINK FOREIGN KEY ("tm_results_id") REFERENCES "ESTAT"."V1"."dat_tm_results" ("id")
)