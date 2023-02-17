#' Run App
#'
#' @returns a shiny app
#' @import shiny
#' @noRd
app_ui <- navbarPage(
    "searchterms",
    tabPanel("Data import",
             fluidPage(
               fluidRow(
                 tags$div(tags$h4(HTML(paste0("Text analysis tool for objective search strategy development")))),
                 tags$div(HTML(paste0(tags$em("Proof of concept version")))),
                 br(),
                 br(),
                 p("Start with uploading your testset."),
                 br(),
                 column(6,

                        fileInput("upload", "Choose testset"),
                 )
               ),
               fluidRow(
                 column(6,
                        actionButton("analyzeTestset", "Analyze all references")
                        ),
                 column(6,
                        actionButton("analyzeDevset", "Create development set and analyze"))
               ),
               br(),
               #fluidRow(
              #   column(4,

               #         downloadButton("downloadDevSet", "Download Development Set"),
                # ),
                 #column(4,

                  #      downloadButton("downloadValSet", "Download Validation Set"),
                 #)
                 #),
               br(),
               tags$hr(),
               p("PMIDS"),
               verbatimTextOutput("outputPMIDs", placeholder = TRUE),
               textOutput("statistikinfo"),
               tags$hr(),
               tableOutput("allRefs")
             )

    ),
    tabPanel("Freetext",
             fluidPage(
               h4("Z-scores: Freetext"),
               tags$hr(),
               downloadButton("downloadFreetext", "Download"),
               br(),
               tableOutput("zScoreFreetext"),
               tags$hr(),
               h4("Simple word frequencies after removal of stopwords, etc."),
               fluidRow(
                 column(6,
                        )
               )
             )
    ),
    tabPanel("MeSH",
             fluidPage(
               h4("Z-scores: MeSH"),
               tags$hr(),
               downloadButton("downloadMeSH", "Download"),
               br(),
               tableOutput("zScoreMeSH"),
               tags$hr(),
               h4("Simple word frequencies after removal of stopwords, etc."),
               fluidRow(
                 column(6,
                 )
               )
             )
    ),
    tabPanel("Qualifier",
             fluidPage(
               h4("Z-scores: Qualifier"),
               tags$hr(),
               downloadButton("downloadQualifier", "Download"),
               br(),
               tableOutput("zScoreQualifier"),
               tags$hr()
             )
    ),
    tabPanel("Keywords in context",
             fluidPage(
               fluidRow(
                 column(6,

                        textInput("kwicInput", "Enter keyword")),
                 column(6,
                        sliderInput("kwicSlider", "Number of context words before/after keyword", 1, 20, 5))
               )
             ),
             fluidRow(
               column(12,
                      #verbatimTextOutput("kwic_analyse1")
                      tableOutput("kwicTable")

               ))

    ),
    tabPanel("Phrases",
             fluidPage(
               fluidRow(
                 column(6,

                        textInput("phraseInput", "Enter phrase")),
                 column(6,
                        sliderInput("phraseSlider", "Number of words between candidate terms", 0, 6, 2))
               )
             ),
             fluidRow(
               column(12,
                      #verbatimTextOutput("kwic_analyse1")
                      tableOutput("phraseTable")

               ))

    ),
    )
