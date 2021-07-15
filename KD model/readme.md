# NLP4Stat Knowledge Database

## Version information

### 1.- The current version of Knowledge Database

- Ontology : version 0.7

- Resources:
  - Statistics Explained website: StatisticsExplainedWebsite_20210714.pdf
  
- Authority lists:
  - NLP4StatRef_ResourceInformation_20210629.rdf
  - NLP4StatRef_ResourceType_20210704.rdf

### 2.- The current workflow for the Knowledge Database

- Ontology : version 0.8 update for:
  - StatisticDataset
  - Dictionary
  - Taxonomy
  - Topics
  
- Resources:
  - Eurostat Glossary
  - Datasets
  - Dictionaries associated to Datasets
  - Database navigation tree
  - Thematics & Categories
  
- Authority lists: updated versions of ResourceInformation & ResourceType

## Ontology

- Current version: NLP4StatRef-Ontology_0.7_20210705.owl  
  - This version is not commented at this stage.
  - Ontologies Dublin core and Skos were not imported.
    - This task is done in the Knowledge database.
	- The association of ontologies is described in mappings and diagrams.
  - The ontology can be read with [protégé](https://protege.stanford.edu/) or a notepad [NotePad++](https://notepad-plus-plus.org/).

- Modeling diagram of Classes and Properties
  - NLP4StatRef-KD-Model_20210715.pdf
  - Upcoming update:
    - Database modeling : dataset, dictionaries, reference metadata & navigation tree
	- News modeling

## Implementation

For each resource integrated into the Content database and the Knowledge database, 2 documents are created:
    - A PDF diagram extracted from the XMind workbook.
    - An Excel spreadsheet containing the mapping for each database.
	
A generic mapping is done for external resources and generic objects : NLP4StatRef-CrossMapping_20210605.xlsx

### 1.- Eurostat website

- Eurostat Glossary: see 3.- Vocabulary
	
- Eurostat Databases: coming soon

- Eurostat reference metadata: coming soon

- Eurostat reference news: coming soon

### 2.- Statistics Explained website

- Statistics Explained Glossary: see 3.- Vocabulary

- Statistics Explained Articles
  - NLP4StatRef-SE-Article-Model_20210715.pdf
  - NLP4StatRef-SE-Article-Mapping_20210715.xlsx
  - Upcoming update:
    - Review and update post KD instanciation
  -	Next updates:
    - Relationship with Categories Taxonomy
	- Dcat integration

- Statistics Explained Background Articles
  - NLP4StatRef-SE-Background-Model_20210715.pdf
  - NLP4StatRef-SE-Background-Mapping_20210715.xlsx
  - Upcoming update:
    - Review and update post KD instanciation
  -	Next updates:
    - Relationship with Categories Taxonomy
	- Dcat integration
	
### 3.- Vocabulary

#### Dictionary

- Eurostat dictionaries: coming soon

#### Glossary

- Eurostat Glossary
  - NLP4StatRef-Eurostat-Glossary-Model_20210715.pdf
  - NLP4StatRef-EurostatGlossaryMapping_20210609.xlsx
  - Upcoming update:
    - Review and update post CD integration & KD instanciation
  -	Next updates:
    - Relationship with Thematics Taxonomy
	- Dcat integration
	
- Statistics Explained Glossary
  - NLP4StatRef-SE-Glossary-Model_20210715.pdf
  - NLP4StatRef-SE-Glossary-Mapping_20210715.xlsx
  - Upcoming updates:
    - Relationship with Categories Taxonomy
	- Dcat integration

#### Taxonomy

- Categories Taxonomy: coming soon

- Thematics Taxonomy: coming soon

## Authority lists

Following the modeling and the work on the data enrichment of the KD, this section will be updated and enriched with new resources.

### 1.- External authority Lists

- Dcat description
  - http://publications.europa.eu/resource/authority/corporate-body
  - https://ec.europa.eu/eurostat/resource/authority/resource-type
  
- Eurostat content, dct:publisher @resource
  - http://publications.europa.eu/resource/authority/corporate-body

### 2.- NLP4StatRef authority lists

- ResourceInformation
  - List of the different source of information describe in the KD
  - This file is also used to populate the KD.
  - Current version : LL-NLP4StatRef_ResourceInformation_20210629.rdf
  - An updated version is on going in order to :
    - introduce more external sources for Use case B ;
	- align it with http://publications.europa.eu/resource/authority/corporate-body for the European Union sources.

- ResourceType
  - List of the different type of content describe in the KD
  - This file is also used to populate the KD.
  - This list is more precise than https://ec.europa.eu/eurostat/resource/authority/resource-type and is centered on the content relevant to the project.
  - Current version : LL-NLP4StatRef_ResourceType_20210704.rdf
  - An updated version is on going following the work on the data enrichment of the KD
