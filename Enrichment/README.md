**1. topic-modeling-lda-vem-v1.ipynb**: R Jupyter notebook implementing the Latent Dirichlet Allocation (LDA) algorithm for topic modeling (Variational Expectation-Maximization -VEM) version. 

An **interactive version** of this document is in Kaggle, **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-vem-v1)**. Pressing **Copy and Edit** (upper right part of the screen) allows to edit the document and experiment with it, **without signing-in**. Unfortunately, the "usual" procedure of producing a Docker image from Binder was failing because the package "topicmodels" could not be loaded. Support for R and R packages in Jupyter notebooks is not very good. 

**2. /LDA_2/topic-modeling-lda-gibbs-v1.ipynb**: R Jupyter notebook of an alternative implementation of the LDA algorithm (with package textmineR and Gibbs sampling) and some more results. The topics are quite similar with the ones with algorithm [1]. Also, transferred to Kaggle, see **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-gibbs-v1)**.

**3. /Spacy_NER/Glossary_NamedEntities_V2.ipynb**: Python Jupyter notebook with test of the Spacy NER engine on the SE Glossary articles.

**Interactive notebook**:
[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Spacy_NER/main?filepath=Glossary_NamedEntities_V2.ipynb)
Please run once to download the English vocabulary, then comment-out the relevant command at the top of the file.


