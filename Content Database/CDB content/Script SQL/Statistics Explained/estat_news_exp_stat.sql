CREATE TABLE "ESTAT"."V1"."dat_exp_statistics" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "content" long varchar,
  "methodology" long varchar,
  "statistics" long varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_EXP_STAT_LINKINFO FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_exp_stat_links" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "exp_stat_id" bigint,
  "link_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_EXPSTAT_LINK FOREIGN KEY ("exp_stat_id") REFERENCES "ESTAT"."V1"."dat_exp_statistics" ("id"),
  CONSTRAINT FK_LINK_EXPSTAT FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_news" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "content" long varchar,
  "publication_date" datetime,
  "euro_indicators" smallint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_NEWS_LINKINFO FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_news_links" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "news_id" bigint,
  "link_id" bigint,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_ESTAT_NEWS_LINK FOREIGN KEY ("news_id") REFERENCES "ESTAT"."V1"."dat_estat_news" ("id"),
  CONSTRAINT FK_LINK_NEWS FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)