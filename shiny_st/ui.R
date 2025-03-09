library(tidyverse)
library(shiny)
library(ggplot2)
library(plyr)
library(dplyr)
library(bslib)
library(bsicons)


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

# Value Boxes
vbs <- list(
  value_box(
    title = "# Genes Available",
    value = "500",
    showcase = bs_icon("bar-chart"),
    theme = "purple"#,
    #p("More to be added")
  ),
  value_box(
    title = "# Visium Spots (display)",
    value = "51208",
    showcase = bs_icon("graph-up"),
    theme = "teal"
  )#,
  # value_box(
  #   title = "# Cell Types",
  #   value = "??",
  #   showcase = bs_icon("pie-chart"),
  #   theme = "pink"
  # )
)



# UI with bslib
ui <- page_sidebar(
  # Theme customization
  theme = bs_theme(
    preset = "flatly",
    version = 5,
    #bootswatch = "flatly",  # A clean, professional theme (try "cosmo", "flatly", etc.)
    #primary = "#6BAED0",      # Darker blue for buttons/links
    #secondary = "#ECF0F1",    # Light gray for contrast
    #font_scale = 1.1          # Slightly larger text
  ),
  
  # Title
  title = "Mouse Kidney Sex Dimorphism - Visium Data",
  
  # Allow dropdown to expand
  tags$head(
    tags$style(HTML("
    /* Ensure card and its body don’t clip content */
    .card {
      overflow: visible !important;
    }
    .card-body {
      overflow: visible !important;
    }
    /* Ensure sidebar and page layout allow overflow */
    .sidebar {
      overflow: visible !important;
    }
    .page-sidebar {
      overflow: visible !important;
    }
    /* Position dropdown correctly */
    .selectize-dropdown {
      z-index: 10000 !important;  /* Appear above other elements */
      position: absolute !important;  /* Position relative to page */
    }
  "))
  ),
  
  # Sidebar layout
  sidebar = sidebar(
    title = 'Plot Options',
    width = 350,  # Wider sidebar for readability
    open = "open", # Starts open, can toggle
    bg = "#F8F9FA",  # Light gray background
    
    # Identity and Gene Selection
    card(
      card_header("Identity and Genes", class = "bg-primary text-white"),
      selectInput(
        inputId = "dim_show",
        label = "Identity to Show",
        choices = ident_options,
        selected = "RCTD_cell_name",
        multiple = FALSE
      ) %>% 
        tooltip("Select the identity type to display on the spatial plot") %>% 
        tagAppendAttributes(class = "form-select-sm"),  # Smaller dropdown
      selectInput(
        inputId = "feature_show",
        label = "Gene to Show",
        choices = feature_options,
        selected = "Lrp2",
        multiple = FALSE
      ) %>% 
        tooltip("Select the features to display on the spatial plot") %>% 
        tagAppendAttributes(class = "form-select-sm"),
      selectInput(
        inputId = "vln_cells",
        label = "Cell Groups for Violin Plot",
        choices = cell_options,
        selected = "epithelial_cells",
        multiple = FALSE
      ) %>% 
        tooltip("Select the features to plot on violin plot") %>% 
        tagAppendAttributes(class = "form-select-sm")
    ),
    
    # Spot Size Slider
    card(
      card_header("Spot Size", class = "bg-primary text-white"),
      sliderInput(
        inputId = "spot_size",
        label = NULL,  # Label in header
        min = 0.1,
        max = 3,
        value = 0.8,
        step = 0.1
      )
    ),
    
    # Age Selection
    card(
      card_header("Age Groups", class = "bg-primary text-white"),
      checkboxGroupInput(
        inputId = "age_show",
        label = NULL,  # Label in header
        choices = c('E165', 'P0', 'W3', 'W12', 'W52', 'W92') %>% 
          setNames(., .) %>% as.list,
        selected = c('E165', 'P0', 'W3', 'W12', 'W52', 'W92'),
        inline = TRUE  # Horizontal layout
      )
    ),
    
    # Download Button - Hide not working atm
    # actionButton(
    #   inputId = "pdf_output",
    #   label = "Download PDF",
    #   class = "btn-primary btn-block mt-2"
    # )
  ),
  
  # Main content
  # Adjust height
  tags$head(
    tags$style(HTML("
      .plot-container { min-height: 450px; }
    "))
  ),
  
  # Value boxes
  layout_column_wrap(
    width = "250px",
    !!!vbs
  ),
  
  # Plots
  layout_columns(
    col_widths = c(12, 12, 12),  # Stack plots vertically
    card(
      full_screen = TRUE,
      card_header("Identity Plot"),
      plotOutput("identPlot")
    ),
    card(
      full_screen = TRUE,
      card_header("Feature Plot"),
      plotOutput("featurePlot")
    ),
    card(
      full_screen = FALSE,
      card_header("Violin Plot"),
      div(class = "plot-container", plotOutput("VlnPlot"))
    )
  ),
  
  # Add custom JS for PDF download
  # sidebar = sidebar(
  #   width = 350,
  #   bg = "#F8F9FA",
  #   # ... other cards ...
  #   card(
  #     card_header("Export", class = "bg-primary text-white"),
  #     downloadButton(
  #       outputId = "pdf_output",
  #       label = "Download PDF",
  #       class = "btn-primary btn-block"
  #     )
  #   )
  # ),
  
  # Add timout preventor
  tags$head(
    tags$script(HTML("
    var socket_timeout_interval;
    var n = 0;
    $(document).on('shiny:connected', function(event) {
      socket_timeout_interval = setInterval(function(){
        Shiny.setInputValue('keepAlive', n++);
      }, 50000); // 50 seconds
    });
    $(document).on('shiny:disconnected', function(event) {
      clearInterval(socket_timeout_interval);
    });
  "))
  )
  
)

  
  

