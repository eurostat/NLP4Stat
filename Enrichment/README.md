## Algorithms in folder NLP4Stat/Enrichment

1. [**topic-modeling-lda-vem-v1.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/topic-modeling-lda-vem-v1.ipynb): R Jupyter notebook implementing the Latent Dirichlet Allocation (LDA) algorithm for topic modeling (Variational Expectation-Maximization -VEM also called Variational Bayes - VB) version. The texts are the contents of the Statistics Explained (SE) Glossary articles, as stored in the Knowledge Database (KD).

    * An **interactive version** of this document is in Kaggle, **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-vem-v1)**. Pressing **Copy and Edit** (upper right part of the screen) allows to edit the document and experiment with it, **without signing-in**. Unfortunately, the "usual" procedure of producing a Docker image from Binder was failing because the package "topicmodels" could not be loaded. Support for R and R packages in Jupyter notebooks is not very good. 

2. [**/LDA_2/topic-modeling-lda-gibbs-v1.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/LDA_2/topic-modeling-lda-gibbs-v1.ipynb): R Jupyter notebook of an alternative implementation of the LDA algorithm (with package textmineR and Gibbs sampling) and some more results. The topics are quite similar with the ones with algorithm [1]. Also, loaded to Kaggle, see **[here](https://www.kaggle.com/spiliopoulos/topic-modeling-lda-gibbs-v1)**.

3. [**/Spacy_NER/Glossary_NamedEntities_V3b.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Spacy_NER/Glossary_NamedEntities_V3b.ipynb): Python Jupyter notebook with test of the Spacy NER engine on the SE Glossary articles as stored in the KD. 

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Spacy_NER/main?filepath=Glossary_NamedEntities_V3b.ipynb)
 
4. [**/Spacy_NER/SE_NamedEntities_V3b.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Spacy_NER/SE_NamedEntities_V3b.ipynb): This is the same algorithm as [3] but run on the scraped content from Statistics Explained articles. The input file is the one produced by scraping, with an additional column gathering all sections titles and contents.  

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Spacy_NER/main?filepath=SE_NamedEntities_V3b.ipynb)
 
5. [**/Gensim/Topic Modelling with Gensim_v6c.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Gensim/Topic%20Modelling%20with%20Gensim_v6c.ipynb): Python Jupyter notebook with comprehensive topic modelling results, with the SE Glossary articles as stored in the KD. The algorithm uses Variational Bayes for inference. The interactive plots with _pyLDAvis_ are produced only in the interactive version below. One cell contains the (disabled) code for an indicative grid search run. Do not comment-out the first line in this cell (%%script false --no-raise-error). Subsequent versions will contain a "smart" search in the hyper-parameters space, probably with Simulated Annealing (SA) or using a specialized library (see for example [Optuna: A hyperparameter optimization framework](https://optuna.readthedocs.io/en/stable/).

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Gensim/main?filepath=Topic%20Modelling%20with%20Gensim_v6c.ipynb)
 
 6. [**/Gensim/Topic Modelling with Gensim_v6c_SE.ipynb**](https://github.com/eurostat/NLP4Stat/blob/main/Enrichment/Gensim/Topic%20Modelling%20with%20Gensim_v6c_SE.ipynb): This is the same algorithm as [5] but run on the scraped content from Statistics Explained articles (with different hyper-parameters). The input file is the one produced by scraping, with an additional column gathering all sections titles and contents. Again, do not comment-out the first command in the disabled cell (%%script false --no-raise-error) which contains an indicative grid search run. 

    * **Interactive notebook**: [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/KSpiliop/Gensim/main?filepath=Topic%20Modelling%20with%20Gensim_v6c_SE.ipynb)



