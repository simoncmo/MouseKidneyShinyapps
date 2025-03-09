library(tidyverse)
library(shiny)
library(ggplot2)
library(plyr)
library(dplyr)


###### Parameters
# Vln
cell_options = c(all = "all", epithelial_cells = "epithelial_cells", developmental = "developmental", 
                 stroma_immue = "stroma_immue", others_mix = "others_mix", `B/Plasma` = "B/Plasma", 
                 CD_IC = "CD_IC", CD_PC = "CD_PC", CNT = "CNT", CS = "CS", CS_NZS_mix = "CS_NZS_mix", 
                 DCT = "DCT", Endo = "Endo", epithelial_aging_enriched = "epithelial_aging_enriched", 
                 Fib = "Fib", IM = "IM", LOH_AL = "LOH_AL", LOH_AL_Endo = "LOH_AL_Endo", 
                 LOH_DL = "LOH_DL", Macro = "Macro", MS = "MS", NP = "NP", NZS = "NZS", 
                 Podo = "Podo", Proliferating = "Proliferating", PT = "PT", PT_Endo_mix = "PT_Endo_mix", 
                 `PT(S1+S2)` = "PT(S1+S2)", `PT(S3)` = "PT(S3)", T = "T", UBP = "UBP", 
                 unknown = "unknown", Uro = "Uro")


#ST plot
ident_options = c('seurat_clusters','RCTD_cell_name') # To be replaced
feature_options = read_tsv('table/feature_options.tsv')$gene


# UI
ui <- fluidPage(
  titlePanel("Mouse Kidney Sex Dimorphism - Visium Data"),

  # Add JS libraries - for PDF output
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/html2canvas/1.4.1/html2canvas.min.js"),
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js")
  ),
  
  # Existing UI
  fluidRow(
    column(3,
           # options
      selectInput(inputId="dim_show",label=h3("Identity to Show"),choices = ident_options, selected = "RCTD_cell_name",multiple = F),
      selectInput(inputId="feature_show",label=h3("Gene to Show"),choices = feature_options, selected = "Lrp2",multiple = F),
      selectInput(inputId='vln_cells', label=h3('Cell groups to show on Violin Plot'), choices = cell_options, selected = 'epithelial_cells', multiple = F),
      sliderInput(inputId = "spot_size",
                  label = h3("Spot Size"),
                  min = 0.1,
                  max = 3,
                  value = 0.8),
      
      # Age 
      checkboxGroupInput(inputId = "age_show", 
                         label = h3("Age to Show"), 
                         #choices  = c('E165','P0','W1','W2','W3','W12','W52','W92','W113') %>% setNames(.,.) %>% as.list,
                         #selected = c('E165','P0','W1','W2','W3','W12','W52','W92','W113') ),
                         choices  = c('E165','P0','W3','W12','W52','W92') %>% setNames(.,.) %>% as.list,
                         selected = c('E165','P0','W3','W12','W52','W92') ),
      # download
      #actionButton("pdf_output", "Download PDF")
    ),
    column(9,
          # Wrap in dev to allow Javascript pdf output
           div(id = "plotContainer",
               plotOutput("identPlot"),
               plotOutput("featurePlot"),
               plotOutput("VlnPlot")
           )
  ),
  
  # Add custom JS for PDF download
  # tags$script(HTML("
  #   console.log('JavaScript loaded');
  #   Shiny.addCustomMessageHandler('downloadPDF', function(message) {
  #     console.log('Download PDF triggered with date: ' + message.date);
  #     const { jsPDF } = window.jspdf;
  #     if (!jsPDF) {
  #       console.error('jsPDF not loaded');
  #       return;
  #     }
  #     const plotContainer = document.querySelector('#plotContainer');
  #     if (!plotContainer) {
  #       console.error('Plot container not found');
  #       return;
  #     }
  #     html2canvas(plotContainer).then(canvas => {
  #       console.log('Canvas generated, width: ' + canvas.width + ', height: ' + canvas.height);
  #       const imgData = canvas.toDataURL('image/png');
  #       const pdf = new jsPDF('p', 'mm', 'a4');
  #       const width = pdf.internal.pageSize.getWidth();
  #       const height = pdf.internal.pageSize.getHeight();
  #       pdf.addImage(imgData, 'PNG', 0, 0, width, height);
  #       pdf.save('kidney_plots_' + message.date + '.pdf');
  #       console.log('PDF saved');
  #     }).catch(error => {
  #       console.error('html2canvas error: ', error);
  #     });
  #   });
  # "))

 )
)

