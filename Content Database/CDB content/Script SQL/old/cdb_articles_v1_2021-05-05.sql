CREATE TABLE "ESTAT"."V1"."mod_source" (
  "id" integer NOT NULL IDENTITY (START WITH 1),
  "label" varchar NOT NULL,
  "url" varchar NOT NULL,
  PRIMARY KEY ("id")
)

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
