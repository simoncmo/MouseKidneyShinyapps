# v2 - Use SQL
library(shiny)
library(ggplot2)
library(dplyr)
library(readr)
library(patchwork)
library(qs)

library(DBI)
library(RSQLite)


# Load function and color
source('functions/plot_functions.R')
source('functions/Kidney_colorset_v4_12132021.R')

# Load data and process table ---------------------------------------------

# Define server logic required to draw a histogram ----
server <- function(input, output, session){
  # 2025-03-09 use SQLite to load data as needed
  con <- dbConnect(SQLite(), "table/st_df.sqlite")
  
  filtered_data <- reactive({
    query <- sprintf("SELECT id, Sex, Age, imagecol, imagerow, RCTD_cell_name, seurat_clusters, %s FROM spatial_data WHERE Age IN (%s)",
                     input$feature_show,
                     paste(sprintf("'%s'", input$age_show), collapse = ","))
    print(query)
    dbGetQuery(con, query)
  })
  
  ## vals will contain all plot and table grobs
  vals <- reactiveValues(p1=NULL,p2=NULL,p3=NULL)
  
  # 1. Cell ST plot
  output$identPlot <- renderPlot({
    print(filtered_data() %>% head)
    p_ident <- make_normal_kidney_shiny(plot_df = filtered_data(), variables = input$dim_show, plt_mode = 'ident', col_cell_all = col_cell_all, input = input) +
      labs(x="",y="",title=paste("Distribution of ",input$dim_show, sep = " ")) + 
      theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 20),
            strip.text = element_text(hjust = 0.5, face = 'bold', size = 12),
      )
    vals$p1 = p_ident
    p_ident
  })
  
  # 2. Feature ST
  output$featurePlot <- renderPlot({
    p_st <- make_normal_kidney_shiny(plot_df = filtered_data(), variables = input$feature_show, plt_mode = 'feature', input = input) +
      labs(x="",y="",title=paste("Expression of ",input$feature_show, sep = " ")) + 
      theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 20),
            strip.text = element_text(hjust = 0.5, face = 'bold', size = 12),
      )
    vals$p2 = p_st
    p_st
  })
  # 3. Vln Plot
  output$VlnPlot <- renderPlot({
    p_vln <- plot_st_vln_shiny(st_df = filtered_data(), feature = input$feature_show, group.by = 'RCTD_cell_name', cell_group_show = input$vln_cells) +
      labs(x="",y="",title=paste("Expression of ",input$feature_show, sep = " ")) + 
      theme(plot.title = element_text(hjust = 0.5, face = 'bold', size = 20),
            strip.text = element_text(hjust = 0.5, face = 'bold', size = 12),
      )
    vals$p3 = p_vln
    p_vln
  })
  
  # # 4 Download handler
  # output$pdf_output <- downloadHandler(
  #   filename = function() {
  #     paste("kidney_plots_", Sys.Date(), ".pdf", sep = "")
  #   },
  #   content = function(file) {
  #     # Create a PDF file
  #     pdf(file, width = 19, height = 18)
  #     
  #     # Print plots that exist in vals
  #     plot_list <- list()
  #     if (!is.null(vals$p1)) plot_list <- c(plot_list, list(vals$p1))
  #     if (!is.null(vals$p2)) plot_list <- c(plot_list, list(vals$p2))
  #     if (!is.null(vals$p3)) plot_list <- c(plot_list, list(vals$p3))
  #     
  #     if (length(plot_list) > 0) {
  #       print(wrap_plots(plot_list, ncol = 1))
  #     } else {
  #       plot.new()
  #       text(0.5, 0.5, "No plots available to export", cex = 2)
  #     }
  #     
  #     dev.off()
  #   },
  #   contentType = "application/pdf"
  # )
  # 
  # # message for downloadPDF
  # observeEvent(input$pdf_output, {
  #   # Add a delay to ensure plots are rendered
  #   Sys.sleep(1)  # Wait 1 second
  #   session$sendCustomMessage("downloadPDF", list(date = Sys.Date()))
  # })
  
  session$onSessionEnded(function() { dbDisconnect(con) })
}
