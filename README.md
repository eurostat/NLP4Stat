# NLP4Stat
## Project organisation
- [Software Environment](Software%20Environment): contains instructions how to install and connect to the Virtuoso server 
- [Content Database](Content%20Database): contains instructions how to setup, scrape and load the data in the content database 
- [Knowledge Database](Content%20Database) - **under construction**
- Use Case A:
    - [Use Case A Widgets Demo](Use%20Case%20A/Use%20Case%20A%20Widgets%20Demo) : for demonstration of ipywidgets only, as part of deliverable D3.1. This is **superseded** by the next codes which are part of deliverable D3.2. 
    - [Use Case A Query builder](Use%20case%20A/Use%20Case%20A%20Query%20builder): Script towards a query builder, still based only on scraped content (the latest version from both Glossary articles and Statistics Explained articles). 

    - [Use Case A Faceted search](Use%20case%20A/Use%20Case%20A%20Faceted%20search): Faceted search, with inputs from the database (SE articles) except from one file (scraped categories per article - these are in the process of being transferred to the knowledge database). Among others, the code assigns the majority of the SE articles to (possibly more than one) themes, sub-themes and categories. **See folder for revisions, January 2022**.

    - [Use Case A Graphical exploration](Use%20Case%20A/Use%20Case%20A%20Graphical%20exploration). Two applications for graphical exploration, one in R Shiny and another in MS Power BI. See separate description in this link. The description includes links to short documentations for the two applications.  **See folder for revisions, January 2022**.

- Use Case B:
     - [Query_Builder_Use_Case_B_v7.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Query_Builder_Use_Case_B_v7.ipynb). Query builder using content from the SE Glossary articles, the SE articles and [OECD's Glossary of Statistical Terms](https://stats.oecd.org/glossary/). OECD's content is read from file [OECD_final_results_2.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/OECD_final_results_2.xlsx). This file is produced by the scraping code [Scraping_OECD_v8_0810.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Scraping_OECD_v8_0810.ipynb).
     - [Faceted_Search_Use_Case_B_v5.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Faceted_Search_Use_Case_B_v5.ipynb). Using Eurostat themes and sub-themes to search articles from the OECD's Glossary of Statistical Terms. OECD's content is read from file [OECD_final_results_2.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/OECD_final_results_2.xlsx). The correspondence between a) Eurostat's themes and sub-themes and b) OECD's Glossary themes is taken from file [themes_eurostat_oecd_v2.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/themes_eurostat_oecd_v2.xlsx). This code includes **temporarily** a chunk producing an input file for a Power BI application (work in progress). **Note:** [Faceted_Search_Use_Case_B_v5_rev_Jan2022.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Faceted_Search_Use_Case_B_v5_rev_Jan2022.ipynb) is a revised version (January 2022) which loads all data from the database.
     - [Power BI](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Power%20BI). An MS Power BI application. See separate documentation in this folder.
     - [SE_OECD_Glossary_Common_NPs.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/SE_OECD_Glossary_Common_NPs.ipynb). This code finds common noun-phrases in Statistics Explained articles and OECD's Glossary articles. The objective was to create a common vocabulary for the labelling of both sources. This code accepts as input the external file [Termino V2.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Termino%20V2.xlsx) which has a manual filtering of the noun phrases found in the SE articles, keeping the most "useful" ones.
The common vocabulary is being used in the [Power BI](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Power%20BI) application in Use Case B. The output file [SE_vs_OECD_Glossary_Noun_Phrases.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/SE_vs_OECD_Glossary_Noun_Phrases.xlsx) is also included here. 
     - [Topic_modelling_application_OECD_v2.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Topic_modelling_application_OECD_v2.ipynb): This is a **demonstration code** showing the application of topic modelling results based on Eurostat's content to OECD Glossary articles. The output file [tm_OECD.xlsx](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/tm_OECD.xlsx) shows the closest topics with probability >= 0.4, for each OECD article. The model is new, based on both SE articles and SE Glossary articles, hence different from the models submitted as part of the [enrichment in deliverable D2.2](https://github.com/eurostat/NLP4Stat/tree/testing/Content%20Database/Enrichment) and has a better overall coherence score (0.54). It is a demonstration code because the output only serves to show agreement between articles and topics and is not in the normal format for storage in the database (i.e. as probabilities for each topic and *term* together with the probabilities of each topic per article).
     - [Scraping_OECD_v9_2911.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Scraping_OECD_v9_2911.ipynb): This is an extension of [Scraping_OECD_v8_0810.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Scraping_OECD_v8_0810.ipynb) for the scraping of OECD's content and the writing of the scraped content in the Content Database. The other codes will be adjusted to read OECD's content directly from the database.
     
- Use Case C:
     - [Eurostat_word_vectors_identify_datasets_v4.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20C/Eurostat_word_vectors_identify_datasets_v4.ipynb). Word vectors trained on SE articles and SE Glossary articles. Application for the identification of Eurostat datasets. The processing of SE and SE Glossary articles is for the first run only, to save the vectors model. After this, it suffices to load the model. This is also saved in plain text format for inspection: [SE_GL_wordvectors.txt](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20C/SE_GL_wordvectors.txt). Requires the file _table_of_contents.xml_ in the same folder as the notebook.
    - [Topic Modelling_and_Word_embeddings_v2.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20C/Topic%20Modelling_and_Word_embeddings_v2.ipynb). Combination of topic modelling and word embeddings for the identification of statistical datasets. Requires the file _table_of_contents.xml_ in the same folder as the notebook. Also, the saved LDA model (_lda_model.pl_, also in the same folder, see file contained in compressed file [lda_model.rar](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20C/lda_model.rar)), if this model is **not** re-created (see comments in code).
        - Carry-out topic modelling with a large enough corpus (Statistics Explained articles and Statistics Explained Glossary articles) and a large number of topics (1000) and extract significant (lemmatized) keywords. The objectives are two:
            - to cover the whole corpus and thus the "correlated" datasets at a high granularity,
            - avoid using common ("dominating") words in the matches with the user's query.
        - Enhance these keywords with their closest terms from the word embeddings created exclusively from Eurostat's content. The total large number of keywords can then differentiate the datasets.
        - Match the (similarly enhanced) sentence(s) entered in the query, with datasets, based on the number of keywords found in the datasets (simple or full descriptions).
        - Put first priority to the matches with words in the enhanced topic modelling dictionary and second to the matches with any other words, to avoid "dominating" terms.
        - The union of the topic modelling keywords found in the datasets descriptions (enhanced or not) can also be used as multi-labels in a multi-label classification algorithm such as BERT.
        - The data with the multi-labels are optionally produced in this code.





