CREATE TABLE "ESTAT"."V1"."dat_link_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "title" varchar NOT NULL,
  "url" varchar NOT NULL,
  "eurostat" smallint NOT NULL DEFAULT 1,
  PRIMARY KEY ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_concept" (
  "id" bigint NOT NULL,
  "definition" long varchar NOT NULL,
  "redirection" smallint NOT NULL DEFAULT 0,
  "homepage" smallint NOT NULL DEFAULT 0,
  "last_update" timestamp DEFAULT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_CONCEPT FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_further_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_FURTHER_INFO FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_CONCEPT_FURTHER_INFO FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_related_concepts" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_RELATED_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_CONCEPT_RELATED_CONCEPTS FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_sources" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_SOURCES_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_CONCEPT_SOURCES_CONCEPTS FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_statistical_data" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_STAT_DATA_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_CONCEPT_STAT_DATA_CONCEPTS FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_redirections" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "concept_id" bigint NOT NULL,
  "link_id" bigint NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_LINK_REDIRECTION_CONCEPTS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
  CONSTRAINT FK_CONCEPT_REDIRECTION_CONCEPTS FOREIGN KEY ("concept_id") REFERENCES "ESTAT"."V1"."dat_concept" ("id")
)