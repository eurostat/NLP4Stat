Use Case A - Query builder. Work in progress, with scraped content only (SE Glossary articles).
* File [Query_Builder_Senario_A_v6.ipynb](Query_Builder_Senario_A_v6.ipynb): This receives inputs from an offline file (scraped content from the SE Glossary articles).
* Interactive version of the above: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Query_builder/main?filepath=Query_Builder_Senario_A_v6.ipynb) 


* File [Query_Builder_Senario_A_v6b.ipynb](Query_Builder_Senario_A_v6b.ipynb): This receives inputs directly from the database (again, scraped content from the SE Glossary articles). Please replace your user name and password in the command c = pyodbc.connect('DSN=Virtuoso All; DBA=ESTAT; UID=user_name; PWD=password'). 

* File [Query_Builder_Senario_A_v6b_both_GL_SE.ipynb](Query_Builder_Senario_A_v6b_both_GL_SE.ipynb): This also receives inputs directly from the database. It is a little slower but accepts content from **both Glossary articles and SE articles with result to much richer 'suggestions'**. The speed is mostly affected by the quality of the connection to the Virtuoso database. Please replace your user name and password in the command  
c = pyodbc.connect('DSN=Virtuoso All; DBA=ESTAT; UID=user_name; PWD=password'). 
