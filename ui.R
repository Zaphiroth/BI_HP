# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
# ProjectName:  BI Shiny Bidding 
# Purpose:      Shiny dashboard
# programmer:   Xin Huang
# Date:         09-08-2017
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #

##-- load the required packages
library(shinydashboard)
library(plotly)
library(DT)
library(shinyjs)
library(leaflet)
library(leafletCN)
library(shinyWidgets)


##-- App part
ui <- dashboardPage(
  dashboardHeader(title = "IMS CHPA Data Sheet"),
  dashboardSidebar(
    tags$head(includeCSS('./www/fix_siderbar.css')),
    collapsed = FALSE,
    fluidRow(column(12, fileInput('summary', 'Upload CHPA Data'))),
    fluidRow(tags$div(
      tags$div(column(1, actionButton("goButton", "Go!")),
               style = "display:inline-block;margin-down: 1px;vertical-align:middle"),
      
      tags$style(".skin-blue .sidebar a { color: #444; }"),
      
      tags$div(column(#offset = 1, 
                      2,
                      downloadButton(outputId = "downloadData", 
                                     label = "Download")),
               style = "display:inline-block;margin-down: 1px;vertical-align:middle"))),
    
    selectInput("TA", "TA",
                c(#"ARB" = "ARB",
                  "Diabetes" = "Diabetes",
                  "General" = "Others",
                  "Onco" = "Onco"),
                selected = "Others"),
    
    selectInput(
      "window",
      "Length",
      c(
        "1 year" = 1,
        "2 years" = 2,
        "3 years" = 3,
        "4 years" = 4,
        "5 years" = 5
      ),
      selected = 1
    ),
    # fluidRow(column(
    #   6,
    #  
    #   selectInput(
    #     "TA",
    #     "TA",
    #     c(
    #       "ARB" = "ARB",
    #       "Diabetes" = "Diabetes",
    #       "General" = "Others",
    #       "Onco" = "Onco"
    #     ),
    #     selected = "Others"
    #   )
    # ),
    # 
    # column(
    #   6,
    # 
    #   selectInput(
    #     "window",
    #     "Length",
    #     c(
    #       "1 year" = 1,
    #       "2 years" = 2,
    #       "3 years" = 3,
    #       "4 years" = 4,
    #       "5 years" = 5
    #     ),
    #     selected = 1
    #   )
    # )),
    
    selectInput(
      "top",
      "Top No.",
      c(
        "zero" = 0,
        # "three" = 3,
        "five" = 5,
        "ten" = 10,
        "All" = 100000
      ),
      selected = 5
    ),
    
    conditionalPanel(condition="input.tabselected==2", 
                     selectInput(
                       "top2",
                       "Top Brand",
                       c(
                         "zero" = 0,
                         "three" = 3,
                         "five" = 5,
                         "ten" = 10,
                         "All" = 100000
                       ),
                       selected = 10
                     )),
    
    conditionalPanel(condition="input.tabselected==3", 
                     selectInput(
                       "top3",
                       "Top Brand",
                       c(
                         "zero" = 0,
                         "three" = 3,
                         "five" = 5,
                         "ten" = 10,
                         "All" = 100000
                       ),
                       selected = 10
                     )),
    
    
    
    selectInput(
      "period",
      label = ("Period"),
      choices = list(
        "MAT" = "mat",
        "MTH" = "mth",
        "QTR" = "qtr",
        "Rolling QTR" = "rqtr",
        "YTD" = "ytd",
        "YEARLY" = "yrl"
      ),
      selected = "mth"
    ),
    
    selectInput(
      "value",
      label = ("Measure"),
      choices = list(
        "DOT" = "DOT",
        "UNIT" = "UNIT",
        "Value In RMB" = "RENMINBI"
      ),
      selected = "RENMINBI",
      multiple = TRUE
    ) ,
    
    
    selectInput(
      "kpi",
      label = ("Index"),
      choices = list(
        # "Absolute Data" = "abs",
        "Sales" = "abs",
        "MS%" = "ms",
        "MS+/- %" = "mc",
        "GR%" = "gr",
        "EV" = "ev",
        "PI" = "pi"
      ),
      selected = "abs",
      multiple = TRUE
    ),
    # Only show this panel if Custom is selected
    
    selectInput("region", "Region", "", multiple = TRUE),
    
    selectInput("province", "Province", "", multiple = TRUE),
    
    selectInput(
      "category",
      label = ("Category"),
      "",
      multiple = TRUE
    ),
    
    selectInput(
      "subcategory",
      label = ("Subcategory"),
      "",
      multiple = TRUE
    )
    
  ),
  
  dashboardBody(
    # tags$head( tags$script(type="text/javascript",'$(document).ready(function(){
    #                          $(".main-sidebar").css("height","100%");
    #                        $(".main-sidebar .sidebar").css({"position":"relative","max-height": "100%","overflow-y": "auto"})
    #                        })')),
    useShinyjs(),
    br(),
    tabsetPanel(
      tabPanel(strong("Product"), value=1,
               br(),
               fluidRow(
                 box(title = "China Market Summary Value(RMB)",
                     width = 12,
                     solidHeader = TRUE,
                     status = "primary",
                     # Dynamic valueBoxes to show the KPIs
                     # fluidRow(column(offset = 0, width = 1),
                     #          valueBoxOutput("BI_mat_mkt_gr", width = 2),
                     #          valueBoxOutput("BI_mat_bi_gr", width = 2),
                     #          valueBoxOutput("BI_mat_mkt_ms", width = 2),
                     #          valueBoxOutput("BI_mat_mkt_mc", width = 2),
                     #          valueBoxOutput("BI_mat_bi_rank", width = 2)),
                     # # br(),
                     # fluidRow(column(offset = 0, width = 1),
                     #          valueBoxOutput("BI_ytd_mkt_gr", width = 2),
                     #          valueBoxOutput("BI_ytd_bi_gr", width = 2),
                     #          valueBoxOutput("BI_ytd_mkt_ms", width = 2),
                     #          valueBoxOutput("BI_ytd_mkt_mc", width = 2),
                     #          valueBoxOutput("BI_ytd_bi_rank", width = 2)),
                     # # br(),
                     # fluidRow(column(offset = 0, width = 1),
                     #          valueBoxOutput("BI_qtr_mkt_gr", width = 2),
                     #          valueBoxOutput("BI_qtr_bi_gr", width = 2),
                     #          valueBoxOutput("BI_qtr_mkt_ms", width = 2),
                     #          valueBoxOutput("BI_qtr_mkt_mc", width = 2),
                     #          valueBoxOutput("BI_qtr_bi_rank", width = 2)),
                     # # br(),
                     # fluidRow(column(offset = 0, width = 1),
                     #          valueBoxOutput("BI_mth_mkt_gr", width = 2),
                     #          valueBoxOutput("BI_mth_bi_gr", width = 2),
                     #          valueBoxOutput("BI_mth_mkt_ms", width = 2),
                     #          valueBoxOutput("BI_mth_mkt_mc", width = 2),
                     #          valueBoxOutput("BI_mth_bi_rank", width = 2)),
                     # br(),
                     # fluidRow(#tags$head(tags$style(HTML(".small-box {height: 50px}"))),
                     #          column(offset = 0, width = 2),
                     #          valueBoxOutput("BI_mat_mnc_brand_cnt", width = 2),
                     #          valueBoxOutput("BI_mat_local_brand_cnt", width = 2),
                     #          valueBoxOutput("BI_mat_mnc_ms", width = 2),
                     #          valueBoxOutput("BI_mat_local_ms", width = 2))
                     fluidRow(column(3, uiOutput("sub_cat_ui"))),
                     fluidRow(
                       column(width = 6,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table"), style = "font-size:90%")),
                       column(width = 3,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table1"), style = "font-size:90%"))

                     )
                     )
               ),
               
               fluidRow(
                 box(
                   title = "Market Trend Performance", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   
                   fluidRow(
                     br(),
                     column(3, 
                            materialSwitch(inputId = "bp_p", 
                                           label = "Brand Performance",
                                           status = "primary", 
                                           right = TRUE,
                                           value = TRUE)
                            ),
                     column(3, 
                            materialSwitch(inputId = "rpp_p", 
                                           label = "Region&Province Performance",
                                           status = "primary", 
                                           right = TRUE,
                                           value = FALSE)
                     )
                     ),
                   
                   fluidRow(
                     br(),
                     # column(3, selectInput("sub_top", "Top Brand", 
                     #                       choices = NULL,
                     #                       multiple = TRUE)),
                     
                     # column(3, selectInput("sub_measure", "Measure", choices = NULL)),
                     # column(3, selectInput("sub_index", "Index", choices = NULL)),
                     # column(3, 
                     #        selectInput("sub_region", "Region/Province", choices = NULL)
                     #        # uiOutput("ui_sub_region")
                     #        )
                     column(3, uiOutput("sub_top_ui")),
                     column(3, uiOutput("sub_measure_ui")),
                     column(3, uiOutput("sub_index_ui")),
                     column(3, uiOutput("sub_region_ui"))
                   ),
                   
                   fluidRow(column(12,
                                    checkboxInput("label_p",
                                                  "Show Data Labels",
                                                  value = FALSE,
                                                  width = NULL))),
                   
                   fluidRow(tags$div(

                     tags$div(
                       column(9, downloadButton(outputId = "downloadData_p",
                                                label = "Download Plot Data"))
                     ),

                     tags$div(
                       column(3,
                              downloadButton(outputId = "downloadData_p1",
                                             label = "Download Plot Data")),

                       style = "display:inline-block;margin-down: 1px;vertical-align:middle"))),
                   br(),
                   
                   fluidRow(column(6, plotlyOutput("chart", width = "80%", height = "550px")),
                            column(6, plotlyOutput("bar_chart", width = "80%", height = "550px")))
                   
                   # fluidRow(
                   #   br(),
                   #   tags$div(
                   #     column(9,
                   #            downloadButton("downloadPlot_p", "Download Plot"))),
                   #   tags$div(
                   #     column(3,
                   #            downloadButton("downloadPlot_p1", "Download Plot")),
                   #     style = "display:inline-block;margin-down: 1px;vertical-align:middle"
                   #   )
                   #   
                   #     )
                   
                 )
               ),
               
               fluidRow( 
                 br(),
                 box(
                   title = "CHPA Data", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   br(),
                   fluidRow(column(12,div(DT::dataTableOutput("contents"), style = "font-size:80%") ))
                 ))
               
               
               
      ),
      tabPanel(strong("Corporation"), value=2,
               
               br(),
               fluidRow(
                 box(title = "China Market Summary Value(RMB)",
                     width = 12,
                     solidHeader = TRUE,
                     status = "primary",
                     # Dynamic valueBoxes to show the KPIs
                     fluidRow(column(3, uiOutput("sub_cat_c_ui"))),
                     fluidRow(
                       column(width = 6,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table_c"), style = "font-size:90%")),
                       column(width = 3,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table1_c"), style = "font-size:90%"))

                     )
                 )
               ),
               
               fluidRow(
                 box(
                   title = "Market Trend Performance", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   fluidRow(
                     br(),
                     column(3, 
                            materialSwitch(inputId = "bp_p_c", 
                                           label = "Corporation Performance",
                                           status = "primary", 
                                           right = TRUE,
                                           value = TRUE)
                     ),
                     column(3, 
                            materialSwitch(inputId = "rpp_p_c", 
                                           label = "Region&Province Performance",
                                           status = "primary", 
                                           right = TRUE,
                                           value = FALSE)
                     )
                   ),
                   
                   fluidRow(
                     br(),
                     column(3, uiOutput("sub_top_c_ui")),
                     column(3, uiOutput("sub_measure_c_ui")),
                     column(3, uiOutput("sub_index_c_ui")),
                     column(3, uiOutput("sub_region_c_ui"))
                   ),
                   
                   fluidRow(column(12,
                                   checkboxInput("label_c",
                                                 "Show Data Labels",
                                                 value = FALSE,
                                                 width = NULL))),
                 
                   fluidRow(tags$div(
                     
                     tags$div(
                       column(9, downloadButton(outputId = "downloadData_c",
                                                label = "Download Plot Data"))
                     ),
                     
                     tags$div(
                       column(3, 
                              downloadButton(outputId = "downloadData_c1", 
                                             label = "Download Plot Data")),
                       
                       style = "display:inline-block;margin-down: 1px;vertical-align:middle"))),
                   br(),
                   fluidRow(column(6, plotlyOutput("chart_c", width = "80%", height = "550px")),
                            column(6, plotlyOutput("bar_chart_c", width = "80%", height = "550px")))
                   # fluidRow(
                   #   br(),
                   #   tags$div(
                   #     column(9,
                   #            downloadButton("downloadPlot_c", "Download Plot"))),
                   #   tags$div(
                   #     column(3,
                   #            downloadButton("downloadPlot_c1", "Download Plot")),
                   #     style = "display:inline-block;margin-down: 1px;vertical-align:middle"
                   #   )
                   #   
                   # )
                   
                   
                   
                 )
               ),
               
               fluidRow( 
                 br(),
                 box(
                   title = "CHPA Data", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   br(),
                   fluidRow(column(12, div(DT::dataTableOutput("contents_c"), style = "font-size:80%")))
                 ))
               
             
      ),
      tabPanel(strong("Molecule"), value=3,
               fluidRow(
                 br(),
                 box(title = "China Market Summary Value(RMB)",
                     width = 12, 
                     solidHeader = TRUE,
                     status = "primary",
                     # Dynamic valueBoxes to show the KPIs
                     fluidRow(
                       column(width = 6,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table_m"), style = "font-size:90%")),
                       column(width = 3,
                              offset = 1,
                              div(DT::dataTableOutput("summary_table1_m"), style = "font-size:90%"))
                       
                     )
                 )
               ),
               
               fluidRow(
                 box(
                   title = "Market Trend Performance", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   # fluidRow(
                   #   br(),
                   #   column(3, 
                   #          materialSwitch(inputId = "bp_p_m", 
                   #                         label = "Molecule Performance",
                   #                         status = "primary", 
                   #                         right = TRUE,
                   #                         value = TRUE)
                   #   ),
                   #   column(3, 
                   #          materialSwitch(inputId = "rpp_p_m", 
                   #                         label = "Region&Province Performance",
                   #                         status = "primary", 
                   #                         right = TRUE,
                   #                         value = FALSE)
                   #   )
                   # ),
                   
                   # fluidRow(
                   #   br(),
                   #   # column(3, selectInput("sub_top_m", "Top Molecule", choices = NULL,
                   #   #                       multiple = TRUE)),
                   #   # column(3, selectInput("sub_measure_m", "Measure", choices = NULL)),
                   #   # column(3, selectInput("sub_index_m", "Index", choices = NULL)),
                   #   # column(3, 
                   #   #        selectInput("sub_region_m", "Region/Province", choices = NULL)
                   #   #        # uiOutput("ui_sub_region_m")
                   #   #        )
                   #   
                   #   column(3, uiOutput("sub_top_m_ui")),
                   #   column(3, uiOutput("sub_measure_m_ui")),
                   #   column(3, uiOutput("sub_index_m_ui")),
                   #   column(3, uiOutput("sub_region_m_ui"))
                   #   
                   # ),
                   
                   fluidRow(column(12,
                                   checkboxInput("label_m",
                                                 "Show Data Labels",
                                                 value = FALSE,
                                                 width = NULL))),
                   fluidRow(tags$div(
                     
                     tags$div(
                       column(9, downloadButton(outputId = "downloadData_m",
                                                label = "Download Plot Data"))
                     ),
                     
                     tags$div(
                       column(3, 
                              downloadButton(outputId = "downloadData_m1", 
                                             label = "Download Plot Data")),
                       
                       style = "display:inline-block;margin-down: 1px;vertical-align:middle"))),
                   br(),
                   
                   # fluidRow(
                   #   column(offset = 9, 
                   #          3, 
                   #          downloadButton(outputId = "downloadData_m", 
                   #                         label = "Download Plot Data"))
                   # ),
                   fluidRow(column(6, plotlyOutput("chart_m", width = "80%", height = "550px")),
                            column(6, plotlyOutput("bar_chart_m", width = "80%", height = "550px"))),
                   
                   fluidRow(column(6, textOutput("caption")),
                            column(6, textOutput("caption1")))
                   
                   # fluidRow(
                   #   br(),
                   #   tags$div(
                   #     column(9,
                   #            downloadButton("downloadPlot_m", "Download Plot"))),
                   #   tags$div(
                   #     column(3,
                   #            downloadButton("downloadPlot_m1", "Download Plot")),
                   #     style = "display:inline-block;margin-down: 1px;vertical-align:middle"
                   #   )
                   #   
                   # )
                 )
               ),
               
               fluidRow( 
                 br(),
                 box(
                   title = "CHPA Data", status = "primary", solidHeader = TRUE,
                   collapsible = FALSE,
                   width = 12,
                   br(),
                   fluidRow(column(12, div(DT::dataTableOutput("contents_m"), style = "font-size:80%")))
                 ))
               
               
  
      ),
      id = "tabselected"
    )
  )
    
)
