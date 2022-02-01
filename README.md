# NLP4Stat
## Project organisation
- [Software Environment](Software%20Environment): contains instructions how to install and connect to the Virtuoso server 
- [Content Database](Content%20Database): contains instructions how to setup, scrape and load the data in the content database 
- [Knowledge Database](Content%20Database) - **under construction**
- Use Case A:

    - [Use Case A Widgets Demo](Use%20case%20A/Use%20Case%20A%20Widgets%20Demo) : for demonstration of ipywidgets only, as part of deliverable D3.1. This is **superseded** by the next codes which are part of deliverable D3.2. 
    - [Use Case A Query builder](Use%20case%20A/Use%20Case%20A%20Query%20builder): Query builder, with inputs from the database (SE articles and SE Glossary articles). 

    - [Use Case A Faceted search](Use%20case%20A/Use%20Case%20A%20Faceted%20search): Faceted search, with inputs from the database (SE articles). Among others, the code assigns the majority of the SE articles to (possibly more than one) themes, sub-themes and categories. **Revised, January 2022**.

    - [Use Case A Graphical exploration](Use%20case%20A/Use%20Case%20A%20Graphical%20exploration). Two applications for graphical exploration, one in R Shiny and another in MS Power BI. See separate description in this link. The description includes links to short documentations for the two applications.  **Revised, January 2022**.

- Use Case B:
     - [Use Case B Query builder](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Use%20Case%20B%20Query%20builder) : Query builder using content from the SE Glossary articles, the SE articles and [OECD's Glossary of Statistical Terms](https://stats.oecd.org/glossary/). **Revised, January 2022**.
     - [Use Case B Faceted search](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Use%20Case%20B%20Faceted%20search). Using Eurostat themes and sub-themes to search articles from the OECD's Glossary of Statistical Terms. Among others, the code uses a correspondence between a) Eurostat's themes and sub-themes and b) OECD's Glossary themes. **Revised, January 2022**.
     - [Use Case B Graphical exploration - Power BI](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Power%20BI). An MS Power BI application. See separate documentation in this folder. **Revised, January 2022**.
     - [Use Case B SE OECD Common NPs](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Use%20Case%20B%20SE%20OECD%20Common%20NPs). This code finds common noun-phrases in Statistics Explained articles and OECD's Glossary articles. The objective was to create a common vocabulary for the labelling of both sources. This code reads from the database a manual filtering of the noun phrases found in the SE articles, keeping the most "useful" ones. 
The common vocabulary is being used in the [Power BI](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Power%20BI) application in Use Case B. The folder contains also the output file (SE_vs_OECD_Glossary_Noun_Phrases.xlsx). **Revised, January 2022**.
     - [Use Case B Topic Modelling](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Use%20Case%20B%20Topic%20modelling): This is a demonstration code showing the application of topic modelling results based on Eurostat's content to OECD Glossary articles. See also note in this folder. **Revised, January 2022**.
     - [Use Case C Scraping OECD](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20B/Use%20Case%20B%20Scraping%20OECD): Code for the scraping of OECD's Glossary articles and the writing of the scraped content in the Content Database. **Revised, January 2022**.
     
- Use Case C:
    - [Use Case C Word embeddings](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20C/Use%20Case%20C%20Word%20embeddings). Word vectors trained on SE articles and SE Glossary articles. Application for the identification of Eurostat datasets. The processing of SE and SE Glossary articles is for the first run only, to save the vectors model. After this, it suffices to load the model. This is also saved in plain text format for inspection (see file SE_GL_wordvectors.txt in folder).  Revised (February 2022), does no more require the external file _table_of_contents.xml_.
     - [Use Case C Topic modelling and Word embeddings](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20C/Use%20Case%20C%20Topic%20modelling%20and%20Word%20embeddings). Combination of topic modelling and word embeddings for the identification of statistical datasets. Revised (February 2022), no more requires the external file _table_of_contents.xml_. One can either re-create the LDA model or load the saved one from the previous code, from file _lda_model.pl_ contained in compressed file lda_model.rar. A copy is included in the /Data folder. Main features:
        - Carry-out topic modelling with a large enough corpus (Statistics Explained articles and Statistics Explained Glossary articles) and a large number of topics (1000) and extract significant (lemmatized) keywords. The objectives are two:
            - to cover the whole corpus and thus the "correlated" datasets at a high granularity,
            - avoid using common ("dominating") words in the matches with the user's query.
         - Enhance these keywords with their closest terms from the word embeddings created exclusively from Eurostat's content. The total large number of keywords can then differentiate the datasets.
         - Match the (similarly enhanced) sentence(s) entered in the query, with datasets, based on the number of keywords found in the datasets (simple or full descriptions).
         - Put first priority to the matches with words in the enhanced topic modelling dictionary and second to the matches with any other words, to avoid "dominating" terms.
         - The union of the topic modelling keywords found in the datasets descriptions (enhanced or not) can also be used as multi-labels in a multi-label classification algorithm such as BERT.
         - The data with the multi-labels are optionally produced in this code.
     - [Use Case C BERT model](https://github.com/eurostat/NLP4Stat/tree/testing/Use%20case%20C/Use%20Case%20C%20BERT%20model). A BERT model, based on the SentenceTransformers Python framework  which uses the BERT algorithm to compute sentence embeddings. The strategy employed is to use a pre-trained BERT model, fine-tune it to the available corpus, and then use the “retrieve & re-rank pipeline” approach for the ranking of the matches, as is suggested for complex semantic search scenarios. This is a  **Google Colab** notebook and requires GPU for proper running. It also requires setting-up a Google drive to store the model and retrieve it in re-runs, avoiding the long computation time it requires. Revised (February 2022), no more requires the external file _table_of_contents.xml_.




