rm(list=ls())

list.of.packages <- c('shiny','shinydashboard','shinycssloaders','DT','plotly','openxlsx','data.table','stringi')
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]

if(length(new.packages)) install.packages(new.packages)

library(shiny)
library(shinydashboard)
library(shinycssloaders)
library(DT)

library(plotly)
library(openxlsx)
library(data.table)
library(stringi)

ui <- dashboardPage(skin='blue',
                    
    dashboardHeader(title = "NLP4StatRef"),
                    
    dashboardSidebar(
        h3('Display articles options'),
        withSpinner(
        uiOutput("DateFrom")), ## output$DateFrom renders the 
        ## 'year_from_Input' 
        sidebarMenu(
            textInput("keyword", "Filter by keyword in title", ""),
            textInput("abstract", "Filter by keyword in abstract", "")
        )),
    dashboardBody(
        fluidRow(
            infoBoxOutput("last_click", width=20),                                     box(width=NULL, solidHeader = TRUE, 
            withSpinner(
            plotlyOutput("chart",width='100%',height='600px')))
            ), 
        fluidRow(
           box(width=NULL, solidHeader = TRUE, 
          tags$head(tags$style("#articles  {white-space: nowrap;  }")),
          div(
          DT::dataTableOutput("articles"),style = "height:500px; overflow-y: scroll;overflow-x: scroll; font-size:75%; font-family: 'Lucida Console', 'Courier New', monospace;")
          ) 
          )
    )
)


server <- function(input, output, session) {
  #print(sessionInfo())
  inp_file <- grep('^SE_df.*xlsx$',list.files(),value=TRUE)
  inp_file <- inp_file[which.max(file.mtime(inp_file))]
  cat(inp_file)
  dat6 <- as.data.table(read.xlsx(inp_file,
                                  cols=c(4,5,6,11,12,13,14,15)))
  
  #cols=c("title","abstract","url",
  #       "categories","new_date","year",themes",
  #       "sub_themes")
  
  themes_list <- sapply(dat6$themes,function(x) strsplit(x,';'))
  sub_themes_list <- sapply(dat6$sub_themes,function(x) strsplit(x,';'))
  categs_list <- sapply(dat6$categories,function(x) strsplit(x,';'))
  
  
  output$DateFrom <- renderUI({
    numericInput('year_from_Input','From year:',value = min(dat6$year),
    min=min(dat6$year),max=as.integer(format(Sys.Date(), "%Y")),step=1)
  })
  
  matches <- function(df,search_what,column_to_search) {
    ## column_to_search has the terms separated by semicolon
    ## result as a boolean vector
    result <- sapply(df[,column_to_search],function(x) 
      search_what %in% unlist(strsplit(x,';')))
    idx <- which(result) ## indices where TRUE                    
    return(idx)                 
  }
  
  themes = list(
    'General and regional statistics/EU policies'=
      c('Non-EU countries','Regions and cities',
        'Sustainable development goals',
        'Policy indicators'),
    'Economy and finance'= 
      c('Balance of payments','Comparative price levels (PPPs)',
        'Consumer prices',
        'Exchange rates and interest rates','Government finance',
        'National accounts (incl. GDP)'),
    'Population and social conditions'=
      c('Asylum and migration','Crime','Culture','Education and training',
        'Health',
        'Labour market','Living conditions','Population',
        'Social protection',
        'Sport','Youth'),
    'Industry and services'=
      c('Short-term business statistics','Structural business statistics',
        'Business registers','Globalisation in businesses',
        'Production statistics',
        'Tourism'),
    'Agriculture, forestry and fisheries'=
      c('Agriculture','Fisheries','Forestry'),
    'International trade'=
      c('Goods','Services'),
    'Transport'=
      c(),
    'Environment and energy'=
      c('Energy','Environment'),
    'Science, technology and digital society'=
      c('Digital economy and society','Science and technology'))
  
  ids <- c("All themes")
  labels <- c("All themes")
  parents <- c("")
  values <- c(nrow(dat6))
  for(i in 1:length(themes)) {
    theme <-names(themes[i])
    ids <- c(ids,paste0("T:",theme))
    labels <- c(labels,theme)
    parents <- c(parents,"All themes")
    #idx_theme <- which(sapply(dat6$themes,function(x) 
    #                  length(grep(theme,x))>0))
    idx_theme <- which(sapply(themes_list, function(x) any(theme %in% x)))
    #idx_theme <- matches(df=dat6,search_what=theme,column_to_search='themes')
    values <- c(values, length(idx_theme))
    
    sub_themes <- themes[names(themes[i])][[1]]
    if(is.null(sub_themes) | tail(values,1)==0)
      next
    else {
      for(j in 1:length(sub_themes)) {
        sub_theme <- sub_themes[j]
        ids <- c(ids,paste0("S:",sub_theme))
        labels <- c(labels,sub_theme)
        parents <- c(parents,paste0("T:",theme))
        #idx_sub_theme <- which(sapply(dat6$sub_themes,function(x) 
        #                      length(grep(sub_theme,x))>0))
        idx_sub_theme <- which(sapply(sub_themes_list, 
                                      function(x) any(sub_theme %in% x)))        
        #idx_sub_theme <- matches(df=dat6,search_what=sub_theme,
        #column_to_search='sub_themes')
        
        
        idx_theme_sub_theme <- intersect(idx_theme,idx_sub_theme)
        values <- c(values,length(idx_theme_sub_theme))
        categs <- unique(unlist(sapply(
          dat6$categories[idx_theme_sub_theme],
          function(x) strsplit(x,';'))))
        if(is.null(categs) | length(categs)==0)
          next 
        else {          
          for(k in 1:length(categs)) {
            categ <- categs[k]
            if (categ %in% c('Statistical article','Archive - environment',
                             'Authored article','Under construction')) next
            ids <- c(ids,paste0("C",k,":",categ))
            labels <- c(labels,categ)
            parents <- c(parents,paste0("S:",sub_theme))
            #idx_categ <- which(sapply(dat6$categories,function(x) 
            #                  length(grep(categ,x))>0))
            idx_categ <- which(sapply(categs_list, function(x) any(categ %in% x)))            
            #idx_categ <- matches(df=dat6,search_what=categ,
            #                     column_to_search='categories')
            idx_theme_sub_theme_categ <- 
              intersect(idx_theme_sub_theme,idx_categ)
            
            values <- c(values,length(idx_theme_sub_theme_categ))
          }
        }
      }
    }
  }
  
  
  d <- data.frame(
    ids = ids,
    labels = labels,
    parents = parents,
    values = values,
    extras = seq(1,length(labels),1),
    stringsAsFactors = FALSE)
  
  output$chart <- renderPlotly({
    req(d)
    p <- plot_ly(
      d,
      ids = ~ids,
      labels = ~labels,
      parents = ~parents,
      values = ~values,
      type = 'sunburst',
      insidetextorientation = 'radial',
      source="A",
      customdata = ~extras
    )  
    
    p %>% event_register('plotly_click')
  })
  
  item_clicked <- reactiveVal(NULL)
  
  observe({
    current_d_id <- event_data("plotly_click")$customdata[1]
    item_clicked(d$ids[current_d_id])
  })
  
  
  output$last_click <- renderInfoBox({
    s <- ''; theme <- ''; sub_theme <- '';categ <- ''; val=0
    if(!is.null(output_info())) {
      theme <- output_info()[1]
      sub_theme <- output_info()[2]
      categ <- output_info()[3]
      val <- output_info()[4]
    }
    
    infoBox(
      title = '',
      value = tags$p(style = "font-size: 12px;",
        HTML(paste0('Theme: ',theme,br(),'Sub-theme: ',sub_theme,                  br(),'Category: ',categ,br(),'Total articles: ',val))),
      subtitle = '', icon = icon("list"),
      color = "maroon", fill = TRUE)
  })    
  
  output_info <- reactive({
    req(d)
    if(length(item_clicked())==0) {
      theme <- "All"
      sub_theme <- "All"
      categ <- "All"
      val <- nrow(dat6)
      return(c(theme,sub_theme,categ,val))
    }
    
    d_ind <- event_data("plotly_click")$customdata[1]
    if(length(d_ind) == 0) return(NULL)
    id <- d$ids[d_ind]
    kind <- strsplit(id,':')[[1]][1]
    node <- strsplit(id,':')[[1]][2]
    val <- d$values[d_ind]
    theme <- ''; sub_theme <- '' ; categ <- ''
    #cat('\n\nkind:',kind,'\n')
    if(kind=='All themes') {
      theme <- "All"
      sub_theme <- "All"
      categ <- "All"
      val <- nrow(dat6) 
    } else if(kind=='T') {
      theme <- node
      sub_theme <- ''
      categ <- ''  
    } else {
      parent_id <- d$parents[d_ind]
      kind_parent <- strsplit(parent_id,':')[[1]][1]
      #cat('kind_parent:',kind_parent,'\n')
      node_parent <- strsplit(parent_id,':')[[1]][2] 
      if(kind_parent == 'T') { 
        theme <- node_parent
        sub_theme <- node
        categ <- ''  
      } else {
        if(kind_parent == 'S') {
          parent_d_id <- which(d$ids==parent_id)
          grand_id <- d$parents[parent_d_id]
          kind_grand <- strsplit(grand_id,':')[[1]][1]
          #cat('kind_grand:',kind_grand,'\n')
          node_grand <- strsplit(grand_id,':')[[1]][2]  
          theme <- node_grand
          sub_theme <- node_parent
          categ <- node
          
        } else {
          
          print('\nkind_parent in else: ',kind_parent,'\n')
        }
      }
    }
    
    #cat(paste0(theme,sub_theme,categ))
    #cat(paste0("\nTheme: ",theme,'\n'))
    #cat(paste0("Sub-theme: ",sub_theme,'\n'))      
    #cat(paste0("Category: ",categ,'\n'))      
    
    return(c(theme,sub_theme,categ,val))
  })
  
  
  output_data <- reactive({
    req(d)
    idx <- 1:nrow(dat6)
    if(length(item_clicked()) > 0) {
      d_ind <- event_data("plotly_click")$customdata[1]
      
      id <- d$ids[d_ind]
      if(length(id)==0) return(NULL)
      
      kind <- strsplit(id,':')[[1]][1]
      node <- strsplit(id,':')[[1]][2]
      if(kind=='All themes') {
        idx <- 1:nrow(dat6)
      } else if(kind=='T') {
        idx <- which(sapply(themes_list, function(x) any(node %in% x)))
        #idx <- which(sapply(dat6$themes,function(x) 
        #            length(grep(node,x))>0)) 
      } else if(kind=='S') {
        parent <- d$parents[d_ind]
        kind_parent <- strsplit(parent,':')[[1]][1]
        node_parent <- strsplit(parent,':')[[1]][2]
        ## idx_theme <- which(sapply(dat6$themes,function(x) 
        ##  length(grep(node_parent,x))>0))
        idx_theme <- which(sapply(themes_list, function(x) 
          any(node_parent %in% x)))
        idx_sub_theme <- which(sapply(sub_themes_list, function(x) 
          any(node %in% x)))
        #idx_sub_theme <- which(sapply(dat6$sub_themes,function(x) 
        #                       length(grep(node,x))>0))
        idx <- intersect(idx_theme,idx_sub_theme) 
      } else if(substr(kind,1,1)=='C') {
        
        parent <- d$parents[d_ind]
        kind_parent <- strsplit(parent,':')[[1]][1]
        node_parent <- strsplit(parent,':')[[1]][2]
        parent_d_id <- which(d$ids==parent)
        grand_id <- d$parents[parent_d_id]
        kind_grand <- strsplit(grand_id,':')[[1]][1]
        node_grand <- strsplit(grand_id,':')[[1]][2]
        #idx_theme <- which(sapply(dat6$themes,function(x) 
        #                   length(grep(node_grand,x))>0))
        #idx_sub_theme <- which(sapply(dat6$sub_themes,function(x) 
        #                   length(grep(node_parent,x))>0))
        idx_theme <- which(sapply(themes_list, function(x) 
          any(node_grand %in% x)))
        idx_sub_theme <- which(sapply(sub_themes_list, function(x) 
          any(node_parent %in% x)))
        
        
        #idx_categ <- which(sapply(dat6$categories,function(x) 
        #                   length(grep(node,x))>0))
        idx_categ <- which(sapply(categs_list, function(x) 
          any(node %in% x)))        
        idx <- intersect(idx_theme,idx_sub_theme)
        idx <- intersect(idx,idx_categ)
        
        
      } else {
        #cat('null item_cliqued') 
        idx <- 1:nrow(dat6)
      }
    }
    
    idx_from_date <- which(dat6$year >= input$year_from_Input)
    idx <- intersect(idx,idx_from_date)
    
    if(input$keyword != '') {
      idx_words <- which(stri_detect_regex(dat6$title, 
                   paste0(input$keyword), case_insensitive = TRUE))
      
      idx <- intersect(idx,idx_words)
    }
    if(input$abstract != '') {
      idx_abstract <- which(stri_detect_regex(dat6$abstract, 
                      paste0(input$abstract), case_insensitive = TRUE))
      
      idx <- intersect(idx,idx_abstract)
    }
    
    
    if(length(idx)==0) return(NULL)
    
    tmp <- dat6[idx,c('title','url','year','abstract')]
    tmp$url <- 
      paste0("<a href='",tmp$url,"' target='_blank'>",tmp$url,"</a>")    
    return(tmp)
    
  })
  
  
  output$articles <- DT::renderDataTable({
    req(output_data())
    return(output_data())
  }, selection = 'none', caption='Statistics Explained articles',
  escape = FALSE,
  options = list(searchHighlight = TRUE), filter = 'top') 
  
  
  session$onSessionEnded(stopApp)
  
  
}

shinyApp(ui, server)

