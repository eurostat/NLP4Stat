# NLP4Stat
## Project organisation
- [Software Environment](Software%20Environment): contains instructions how to install and connect to the Virtuoso server 
- [Content Database](Content%20Database): contains instructions how to setup, scrape and load the data in the content database 
- [Knowledge Database](Content%20Database) - **under construction**
- Use Case A:
    - [Use Case A Widgets Demo](Use%20Case%20A/Use%20Case%20A%20Widgets%20Demo) : for demonstration of ipywidgets only, as part of deliverable D3.1. This is **superseded** by the next codes which are part of deliverable D3.2. 
    - [Use Case A Query builder](Use%20Case%20A/Use%20Case%20A%20Query%20builder): Script towards a query builder, still based only on scraped content (the latest version from both Glossary articles and Statistics Explained articles). 
    - [Use Case A Faceted search](Use%20Case%20A/Use%20Case%20A%20Faceted%20search): Faceted search, with inputs from the database (SE articles) except from one file (scraped categories per article - these are in the process of being transferred to the knowledge database). Among others, the code assigns the majority of the SE articles to (possibly more than one) themes, sub-themes and categories.
    - [Use Case A Graphical exploration](Use%20Case%20A/Use%20Case%20A%20Graphical%20exploration). Two applications for graphical exploration, one in R Shiny and another in MS Power BI. See separate description in this link. The description includes links to short documentations for the two applications.

- Use Case B:
     - [Query_Builder_Use_Case_B_v6.ipynb](https://github.com/eurostat/NLP4Stat/blob/testing/Use%20case%20B/Query_Builder_Use_Case_B_v6.ipynb). Query builder using content from the SE Glossary articles, the SE articles and [OECD's Glossary of Statistical Terms](https://stats.oecd.org/glossary/). OECD's content is read from file 'OECD_final_results_2.xlsx'.
