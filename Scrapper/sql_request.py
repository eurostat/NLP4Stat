# select eurostat doc id
def estatLinkSelectId():
    estatLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND eurostat = 1"
    return estatLinkSelectId

# select foreign doc id
def foreignLinkSelectId():
    foreignLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND eurostat = 0"
    return foreignLinkSelectId

# insert eurostat doc
def estatLinkInsert():
    estatLinkInsert = "INSERT INTO dat_link_info(title, url, eurostat) VALUES (?, ?, 1)"
    return estatLinkInsert

# insert doc from outside eurostat
def foreignLinkInsert():
    foreignLinkInsert = "INSERT INTO dat_link_info(title, url, eurostat) VALUES (?, ?, 0)"
    return foreignLinkInsert

############################## Glossary queries ############################

# select glossary element
def conceptSelect():
    conceptSelect = "SELECT * FROM dat_concept WHERE id = ?"
    return conceptSelect

# insert glossary element
def conceptFullInsert():
    conceptFullInsert = "INSERT INTO dat_concept(id, definition, last_update, homepage, redirection) VALUES (?, ?, ?, 0, 0)"
    return conceptFullInsert

# insert glossary element
def conceptInsert():
    conceptInsert = "INSERT INTO dat_concept(id, definition, homepage, redirection) VALUES (?, ?, 0, 0)"
    return conceptInsert

# check if couple exists in dat_further_info
def furtherInfoCheck():
   furtherInfoCheck = "SELECT id FROM dat_further_info WHERE concept_id = ? AND link_id =?"
   return furtherInfoCheck

# insert a further_info link
def furtherInfoInsert():
    furtherInfoInsert = "INSERT INTO dat_further_info(concept_id, link_id) VALUES (?, ?)"
    return furtherInfoInsert

# check if couple exists in dat_related_concepts
def relCptCheck():
    relCptCheck = "SELECT id FROM dat_related_concepts WHERE concept_id = ? AND link_id =?"
    return relCptCheck

# insert a concept link
def relCptInsert():
    relCptInsert = "INSERT INTO dat_related_concepts(concept_id, link_id) VALUES (?, ?)"
    return relCptInsert

# check if couple exists in dat_statistical_data
def statDataCheck():
    statDataCheck = "SELECT id FROM dat_statistical_data WHERE concept_id = ? AND link_id =?"
    return statDataCheck

# insert a statistical data link
def statDataInsert():
    statDataInsert = "INSERT INTO dat_statistical_data(concept_id, link_id) VALUES (?, ?)"
    return statDataInsert

# check if couple exists in dat_sources
def sourceCheck():
    sourceCheck = "SELECT id FROM dat_sources WHERE concept_id = ? AND link_id =?"
    return sourceCheck

# insert a source link
def sourceInsert():
    sourceInsert = "INSERT INTO dat_sources(concept_id, link_id) VALUES (?, ?)"
    return sourceInsert

############################## Article queries ############################

# select article element
def articleSelect():
    articleSelect = "SELECT * FROM dat_article WHERE id = ?"
    return articleSelect

# insert article element
def articleFullInsert():
    articleFullInsert = "INSERT INTO dat_article(id, last_update, homepage, background_article) VALUES (?, ?, 0, 0)"
    return articleFullInsert

# insert article element
def articleInsert():
    articleInsert = "INSERT INTO dat_article(id, homepage, background_article, context, data_sources) VALUES (?, 0, 0, '', '')"
    return articleInsert

# add context and data_sources to an existing article
def articleFillExisting():
    articleFillExisting = "UPDATE dat_article SET context = ?, data_sources = ? WHERE id = ? "
    return articleFillExisting

# insert paragraph
def paragraphInsert():
    paragraphInsert = "INSERT INTO dat_article_paragraph(article_id, title, content, abstract, alert) VALUES (?, ?, ?, 0, 0) "
    return paragraphInsert

# insert abstract
def abstractInsert():
    abstractInsert = "INSERT INTO dat_article_paragraph(article_id, title, content, abstract, alert) VALUES (?, ?, ?, 1, 0) "
    return abstractInsert

# insert alert
def alertInsert():
    alertInsert = "INSERT INTO dat_article_paragraph(article_id, title, content, abstract, alert) VALUES (?, ?, ?, 0, 1) "
    return alertInsert

# select paragraph
def paragraphSelect():
    paragraphSelect = "SELECT * FROM dat_article_paragraph WHERE article_id = ? AND title = ?"
    return paragraphSelect

# insert figure
def figureInsert():
    figureInsert = "INSERT INTO dat_paragraph_figure(paragraph_id, link_id) VALUES (?, ?)"
    return figureInsert

# check if couple exists in dat_paragraph_figure
def figureCheck():
   figureCheck = "SELECT id FROM dat_paragraph_figure WHERE paragraph_id = ? AND link_id = ?"
   return figureCheck

# insert shared link
def sharedLinkInsert():
    sharedLinkInsert = "INSERT INTO dat_article_shared_link(article_id, link_id, article_division_id) VALUES (?, ?, ?)"
    return sharedLinkInsert

# check if couple exists in dat_article_shared_link
def sharedLinkCheck():
   sharedLinkCheck = "SELECT id FROM dat_article_shared_link WHERE article_id = ? AND link_id = ? AND article_division_id = ?"
   return sharedLinkCheck