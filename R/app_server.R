#' Run App
#'
#' @returns a shiny app
#' @import shiny
#' @export
#' @noRd
app_server <- function(input, output, session) {
  rawdata <- reactive({
    req(input$upload)
    ext <- tools::file_ext(input$upload$name)
    switch(ext,
           txt = create_testset(input$upload$datapath),
           ris = create_testset(input$upload$datapath),
           validate("Invalid file: Please upload a risfile exported from Endnote")
    )
  })
  zScoreData <- reactive({
    req(input$upload)
    z_scores(input$upload$datapath)
  })
  output$allRefs <- renderTable({
     as.data.frame(rawdata()$reference.list)[c("accession",
                                             "author",
                                             "year",
                                             "title",
                                             "keywords")]
  })
  output$zScoreFreetext <- renderTable({
    zScoreData()$freetext[c("feature", "frequency", "z")]
  })
  output$downloadFreetext <- downloadHandler(
    filename = function(){
      paste0(input$upload,"-freetext.csv")
    },
    content = function(file) {
      write.csv2(zScoreData()$freetext,
                 file)
    }
  )
  output$zScoreMeSH <- renderTable({
    zScoreData()$MeSH
  })
  output$downloadMeSH <- downloadHandler(
    filename = function(){
      paste0(input$upload,"-MeSH.csv")
    },
    content = function(file) {
      write.csv2(zScoreData()$MeSH,
                 file)
    }
  )
  output$zScoreQualifier <- renderTable({
    zScoreData()$qualifier
  })
  output$downloadQualifier <- downloadHandler(
    filename = function(){
      paste0(input$upload,"-qualifier.csv")
    },
    content = function(file) {
      write.csv2(zScoreData()$qualifier,
                 file)
    }
  )
  output$kwicTable <- renderTable({
    req(input$upload)
    quanteda::kwic(tokens(rawdata()$text_corpus), input$kwicInput, case_insensitive = TRUE, window = input$kwicSlider)
  })

  output$phraseTable <- renderTable({
    req(input$upload)
    summarise_adjacency(rawdata()$text_corpus, ngrams = input$phraseSlider) %>%
      filter(grepl(input$phraseInput, feature, fixed = TRUE))
    })
  }

