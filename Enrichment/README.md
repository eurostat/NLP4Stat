**A. tests_topic_mod_v1.md**: Markdown document with title "Topic modelling: tests with the Latent Dirichlet Allocation (LDA) algorithm". 

An **interactive version** of this document is [here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda/notebook). Pressing **Copy and Edit** (upper right part of the screen) allows to edit the document and experiment with it, **without signing-in**. Unfortunately, the "usual" procedure of producing a Docker image from Binder was failing because the package "topicmodels" could not be loaded. Support for R and R packages in Jupyter notebooks is not very good. 

**B. /LDA_2/tests_topic_mod_pack_lda.ipynb**: Jupyter notebook of an alternative implementation of the LDA algorithm using the textmineR package. The topics are quite similar with the ones on algorithm A.

**Interactive notebook**:
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Topic_Modeling/main?filepath=tests_topic_mod_pack_lda.ipynb)
(the interpretation of the topics in the end is not yet updated). **Takes too long to build - transfer to Kaggle**

**C. /Spacy_NER/Glossary_NamedEntities_V2.ipynb**: Jupyter notebook with test of the Spacy NER engine on the SE Glossary articles.

**Interactive notebook**:
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Spacy_NER/main?filepath=Glossary_NamedEntities_V2.ipynb)
Please run once to download the English vocabulary, then comment-out the relevant command at the top of the file.


