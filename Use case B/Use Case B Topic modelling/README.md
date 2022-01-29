## Topic modelling application

This is a demonstration code showing the application of topic modelling results based on Eurostat's content to OECD Glossary articles. The output file (tm_OECD.xlsx) shows the closest topics with probability >= 0.4, for each OECD article. The model is new, based on both SE articles and SE Glossary articles, hence different from the models submitted as part of the [enrichment in deliverable D2.2](https://github.com/eurostat/NLP4Stat/tree/testing/Content%20Database/Enrichment) and has a better overall coherence score (0.54). 

It is a demonstration code because the output only serves to show agreement between articles and topics and is not in the normal format for storage in the database (i.e. as probabilities for each topic and *term* together with the probabilities of each topic per article). 

**Revised, January 2022**.