
/* mod_article_division */
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (0, 'Undefined');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (1, 'Excel');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (2, 'Other articles');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (3, 'Tables');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (4, 'Database');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (5, 'Dedicated Section');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (6, 'Publications');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (7, 'Methodology');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (8, 'Legislation');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (9, 'Visualisation');
INSERT INTO "ESTAT"."V1"."mod_article_division" (id, label) VALUES (10, 'External Link');


/*homepages*/
/*Statistics Explained Glossary homepage*/
INSERT INTO "ESTAT"."V1"."dat_link_info" (title, url, resource_information_id, resource_type_id) VALUES ('Glossary', 'https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Glossary', 1, 5);
INSERT INTO "ESTAT"."V1"."dat_glossary" (id,definition,redirection,homepage,last_update) VALUES ((SELECT id FROM "ESTAT"."V1"."dat_link_info" WHERE url = 'https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Glossary'), 'The Glossary contains short definitions of all terms used in Statistics Explained with additional links to more detailed information. Thematic subglossaries and the list of abbreviations provide more focused entry points to the same items.', 0, 1, '2011-12-20 01:40:00');

/*Statistics Explained Statistical article homepage*/
INSERT INTO "ESTAT"."V1"."dat_link_info" (title, url, resource_information_id, resource_type_id) VALUES ('Statistical article', 'https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Statistical_article', 1, 0);
INSERT INTO "ESTAT"."V1"."dat_article" (id, context, last_update, background_article, homepage) VALUES ((SELECT id FROM "ESTAT"."V1"."dat_link_info" WHERE url ='https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Statistical_article'), 'The category Statistical article contains all statistical articles explaining statistical data from all themes and subthemes.', '2009-08-31 14:49:00', 0, 1);

/*Statistics Explained Background article homepage*/
INSERT INTO "ESTAT"."V1"."dat_link_info" (title, url, resource_information_id, resource_type_id) VALUES ('Background article', 'https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Background_article', 1, 0);
INSERT INTO "ESTAT"."V1"."dat_article" (id, context, last_update, background_article, homepage) VALUES ((SELECT id FROM "ESTAT"."V1"."dat_link_info" WHERE url = 'https://ec.europa.eu/eurostat/statistics-explained/index.php?title=Category:Background_article'), 'The category Background article contains all background articles providing extensive methodological or context information, and thus complementing the statistical articles presenting and analysing data.', '2013-03-27 16:11:00', 1, 1);
