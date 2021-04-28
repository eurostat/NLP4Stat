## Algorithms in folder NLP4Stat/Enrichment

1. [**topic-modeling-lda-vem-v1.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/topic-modeling-lda-vem-v1.ipynb): R Jupyter notebook implementing the Latent Dirichlet Allocation (LDA) algorithm for topic modeling (Variational Expectation-Maximization -VEM also called Variational Bayes - VB) version. 

    * An **interactive version** of this document is in Kaggle, **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-vem-v1)**. Pressing **Copy and Edit** (upper right part of the screen) allows to edit the document and experiment with it, **without signing-in**. Unfortunately, the "usual" procedure of producing a Docker image from Binder was failing because the package "topicmodels" could not be loaded. Support for R and R packages in Jupyter notebooks is not very good. 

2. [**/LDA_2/topic-modeling-lda-gibbs-v1.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/LDA_2/topic-modeling-lda-gibbs-v1.ipynb): R Jupyter notebook of an alternative implementation of the LDA algorithm (with package textmineR and Gibbs sampling) and some more results. The topics are quite similar with the ones with algorithm [1]. Also, loaded to Kaggle, see **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-gibbs-v1)**.

3. [**/Spacy_NER/Glossary_NamedEntities_V3.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Spacy_NER/Glossary_NamedEntities_V3.ipynb): Python Jupyter notebook with test of the Spacy NER engine on the SE Glossary articles.

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Spacy_NER/main?filepath=Glossary_NamedEntities_V3.ipynb) 
    * Please run once only the first chunk to download the English Spacy vocabulary. Then comment-out the relevant command in the first chunk (_!{sys.executable} -m spacy download en_) and run all.

4. [**/Gensim/Topic Modelling with Gensim_v6c.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Gensim/Topic%20Modelling%20with%20Gensim_v6c.ipynb): Python Jupyter notebook with comprehensive topic modelling results. The algorithm uses Variational Bayes for inference. The interactive plots with _pyLDAvis_ are produced only in the interactive version below. 

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Gensim/main?filepath=Topic%20Modelling%20with%20Gensim_v6c.ipynb)
 


