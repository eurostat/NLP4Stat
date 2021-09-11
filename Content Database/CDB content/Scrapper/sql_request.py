# select eurostat doc id
def estatLinkSelectId():
    estatLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND resource_information_id = 1"
    return estatLinkSelectId

# select eurostat doc id
def estatLinkTitleSelectId():
    estatLinkTitleSelectId = "SELECT id FROM dat_link_info WHERE title = ? AND resource_information_id = 1"
    return estatLinkTitleSelectId

# select foreign doc id
def foreignLinkSelectId():
    foreignLinkSelectId = "SELECT id FROM dat_link_info WHERE url = ? AND resource_information_id = 0"
    return foreignLinkSelectId

# insert eurostat doc
def estatLinkInsert():
    estatLinkInsert = "INSERT INTO dat_link_info(title, url, resource_information_id) VALUES (?, ?,  1)"
    return estatLinkInsert

# insert eurostat doc
def estatLinkTypeKnownInsert():
    estatLinkTypeKnownInsert = "INSERT INTO dat_link_info(title, url, resource_type_id, resource_information_id) VALUES (?, ?, ?, 1)"
    return estatLinkTypeKnownInsert


# insert doc from outside eurostat
def foreignLinkInsert():
    foreignLinkInsert = "INSERT INTO dat_link_info(title, url, resource_information_id) VALUES (?, ?, 0)"
    return foreignLinkInsert

# get all urls with no resource_type
def LinkNoTypeSelect():
    LinkNoTypeSelect = "SELECT id, url FROM dat_link_info WHERE resource_type_id = 0 OR resource_type_id IS NULL"
    return LinkNoTypeSelect

# set resource_type
def LinkTypeUpdate():
    LinkTypeUpdate = "UPDATE dat_link_info SET  resource_type_id = ? WHERE id = ?"
    return LinkTypeUpdate


# get all urls with no resource_information
def LinkNoResourceInfoSelect():
    LinkNoResourceInfoSelect = "SELECT id, url FROM dat_link_info WHERE resource_information_id = 0 OR resource_information_id IS NULL"
    return LinkNoResourceInfoSelect

# set resource_information
def LinkResourceInfoUpdate():
    LinkResourceInfoUpdate = "UPDATE dat_link_info SET  resource_information_id = ? WHERE id = ?"
    return LinkResourceInfoUpdate


############################## Glossary queries ############################

# select glossary element
def glossarySelect():
    glossarySelect = "SELECT * FROM dat_glossary WHERE id = ?"
    return glossarySelect

# insert glossary element
def glossaryFullInsert():
    glossaryFullInsert = "INSERT INTO dat_glossary(id, definition, last_update, homepage, redirection) VALUES (?, ?, ?, 0, 0)"
    return glossaryFullInsert

# insert glossary element
def glossaryRedirectFullInsert():
    glossaryRedirectFullInsert = "INSERT INTO dat_glossary(id, definition, last_update, homepage, redirection, original_title) VALUES (?, ?, ?, 0, 1, ?)"
    return glossaryRedirectFullInsert

# insert glossary element
def glossaryInsert():
    glossaryInsert = "INSERT INTO dat_glossary(id, definition, homepage, redirection) VALUES (?, ?, 0, 0)"
    return glossaryInsert

# insert glossary element with redirection
def glossaryRedirectInsert():
    glossaryRedirectInsert = "INSERT INTO dat_glossary(id, definition, homepage, redirection, original_title) VALUES (?, ?, 0, 1, ?)"
    return glossaryRedirectInsert

# check if couple exists in dat_further_info
def furtherInfoCheck():
   furtherInfoCheck = "SELECT id FROM dat_further_info WHERE glossary_id = ? AND link_id =?"
   return furtherInfoCheck

# insert a further_info link
def furtherInfoInsert():
    furtherInfoInsert = "INSERT INTO dat_further_info(glossary_id, link_id) VALUES (?, ?)"
    return furtherInfoInsert

# check if couple exists in dat_related_concepts
def relCptCheck():
    relCptCheck = "SELECT id FROM dat_related_concepts WHERE glossary_id = ? AND link_id =?"
    return relCptCheck

# insert a concept link
def relCptInsert():
    relCptInsert = "INSERT INTO dat_related_concepts(glossary_id, link_id) VALUES (?, ?)"
    return relCptInsert

# check if couple exists in dat_statistical_data
def statDataCheck():
    statDataCheck = "SELECT id FROM dat_statistical_data WHERE glossary_id = ? AND link_id =?"
    return statDataCheck

# insert a statistical data link
def statDataInsert():
    statDataInsert = "INSERT INTO dat_statistical_data(glossary_id, link_id) VALUES (?, ?)"
    return statDataInsert

# check if couple exists in dat_sources
def sourceCheck():
    sourceCheck = "SELECT id FROM dat_sources WHERE glossary_id = ? AND link_id =?"
    return sourceCheck

# insert a source link
def sourceInsert():
    sourceInsert = "INSERT INTO dat_sources(glossary_id, link_id) VALUES (?, ?)"
    return sourceInsert

# check if couple exists in dat_sources
def redirectionCheck():
    redirectionCheck = "SELECT id FROM dat_redirections WHERE glossary_id = ? AND link_id =?"
    return redirectionCheck

# insert a source link
def redirectionInsert():
    redirectionInsert = "INSERT INTO dat_redirections(glossary_id, link_id) VALUES (?, ?)"
    return redirectionInsert

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

# insert background article element
def backgroundArticleFullInsert():
    backgroundArticleFullInsert = "INSERT INTO dat_article(id, last_update, homepage, background_article) VALUES (?, ?, 0, 1)"
    return backgroundArticleFullInsert

# insert article element
def backgroundArticleInsert():
    backgroundArticleInsert = "INSERT INTO dat_article(id, homepage, background_article, context, data_sources) VALUES (?, 0, 1, '', '')"
    return backgroundArticleInsert

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

############################## News queries ############################

# insert a news
def newsFullInsert():
    newsFullInsert = "INSERT INTO dat_estat_news(id, publication_date, euro_indicators) VALUES (?, ?, 0)"
    return newsFullInsert

def newsInsert():
    newsInsert = "INSERT INTO dat_estat_news(id, euro_indicators, body) VALUES (?, 0)"
    return newsInsert

# update a news / add the body
def newsUpdate():
    newsUpdate = "UPDATE dat_estat_news SET body = ? WHERE id = ?"
    return newsUpdate

# insert an euro_indicator
def euroIndicFullInsert():
    euroIndicFullInsert = "INSERT INTO dat_estat_news(id, publication_date, euro_indicators) VALUES (?, ?, 1)"
    return euroIndicFullInsert

def euroIndicInsert():
    euroIndicInsert = "INSERT INTO dat_estat_news(id, euro_indicators, body) VALUES (?, 1)"
    return euroIndicInsert

# select a news or an euro_indicator
def newsSelect():
    newsSelect = "SELECT id FROM dat_estat_news WHERE id = ?"
    return newsSelect

# insert news more info link
def moreInfoInsert():
    moreInfoInsert = "INSERT INTO dat_estat_news_more_info(news_id, link_id) VALUES (?, ?)"
    return moreInfoInsert

# check if couple exists in dat_article_shared_link
def moreInfoCheck():
   moreInfoCheck = "SELECT id FROM dat_estat_news_more_info WHERE news_id = ? AND link_id = ? "
   return moreInfoCheck
