CREATE TABLE "ESTAT"."V1"."dat_glossary" (
  "id" bigint NOT NULL,
  "definition" long varchar NOT NULL,
  "redirection" smallint NOT NULL DEFAULT 0,
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