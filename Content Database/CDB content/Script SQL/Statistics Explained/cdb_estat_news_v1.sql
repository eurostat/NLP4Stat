
CREATE TABLE "ESTAT"."V1"."dat_estat_news" (
  "id" bigint NOT NULL,
  "publication_date" datetime,
  "euro_indicators" smallint ,
  "body" varchar,
  PRIMARY KEY ("id"),
  CONSTRAINT FK_NEWS_LINK FOREIGN KEY ("id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id")
)

CREATE TABLE "ESTAT"."V1"."dat_estat_news_more_info" (
  "id" bigint NOT NULL IDENTITY (START WITH 1),
  "news_id" bigint,
  "link_id" bigint 
  PRIMARY KEY ("id"),
  CONSTRAINT FK_NEWS_INFO FOREIGN KEY ("news_id") REFERENCES "ESTAT"."V1"."dat_estat_news" ("id"),
  CONSTRAINT FK_LINK_INFO FOREIGN KEY ("link_id") REFERENCES "ESTAT"."V1"."dat_link_info" ("id"),
)