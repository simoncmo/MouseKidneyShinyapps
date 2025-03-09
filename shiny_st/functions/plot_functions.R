# Plot functions
source('functions/function_kidney_overview_plot_only.R')

# Cell
cell_all = c("B/Plasma", "CD_IC", "CD_PC", "CNT", "CS", "CS_NZS_mix", "DCT", 
             "Endo", "epithelial_aging_enriched", "Fib", "IM", "LOH_AL", "LOH_AL_Endo", 
             "LOH_DL", "Macro", "MS", "NP", "NZS", "Podo", "Proliferating", 
             "PT", "PT_Endo_mix", "PT(S1+S2)", "PT(S3)", "T", "UBP", "unknown", 
             "Uro")
cell_list = list(all = cell_all ,
                 epithelial_cells = c("PT",  "Podo", "LOH_AL", "LOH_DL", "DCT", "CNT", "PT(S1+S2)", "PT(S3)", "CD_PC",  "CD_IC",  "epithelial_aging_enriched"),
                 developmental = c("CS", "CS_NZS_mix","NP", "NZS", "MS","IM", "UBP"),
                 stroma_immue = c("Endo","Fib","Macro","T","B/Plasma"),
                 others_mix = c("Proliferating", "Uro","LOH_AL_Endo", "PT_Endo_mix")
)
cell_list_all = c(cell_list, cell_all %>% setNames(.,.) %>% as.list())



###### ST PLOT
make_normal_kidney_shiny = function(plot_df, variables, plt_mode = c('feature','ident') , col_cell_all, input, direction = c('horizontal','vertical')){
  # Parameters
  plt_mode = match.arg(plt_mode)
  direction = match.arg(direction)
  direction_formula = as.formula(switch(direction, 
                                        'vertical'='Age~Sex', 
                                        'horizontal'='Sex~Age'
  ))
  # Make sure ident in right format
  if(plt_mode == 'ident') plot_df[[variables]] = as.character(plot_df[[variables]] )
  
  # Plot
  p = ggplot(plot_df, aes(x = imagecol, y = imagerow, fill = .data[[variables]])) + 
    geom_point(size =input$spot_size, shape =21, color = 'transparent') + 
    facet_grid(direction_formula, switch = 'y') + 
    coord_fixed() +
    theme_void() +
    theme(legend.position = 'bottom') 
  
  # Guide layout
  if(plt_mode =='ident') p = p + guides(fill = guide_legend(nrow=3)) # Guide row
  
  # Color scale
  p = add_kidney_celltype_colors(p, variables, plt_mode, col_cell_all, aes_mode = 'fill')
  
  # Adjust spacing
  p = gg_remove_spacing(p)
  p
}

###### Violin plot
plot_st_vln_shiny = function(st_df, feature, group.by, cell_group_show){
  # Select cell group
  cell_to_show = cell_list_all[cell_group_show] %>% unlist()
  # Plot
  st_df %>% 
    filter(.data[[group.by]] %in% cell_to_show) %>% # Filter by cell to show
    ggplot(aes(x = .data[[group.by]], y = .data[[feature]], fill = .data[[group.by]])) + 
    geom_violin(color = 'transparent') + 
    facet_grid(Sex~Age, space = 'free', scales = 'free', switch='y') + 
    scale_fill_manual(values = col_cell_all[cell_to_show]) + 
    theme_bw() + 
    theme(legend.position = 'bottom',panel.grid = element_blank(), 
          panel.background = element_rect(fill = NA), 
          strip.background = element_blank()) + 
    guides(fill = guide_legend(nrow = 3)) + 
    RotatedAxis()
}

#### Seurat function
RotatedAxis = function(...){
  {
    rotated.theme <- theme(axis.text.x = element_text(angle = 45, 
                                                      hjust = 1), validate = TRUE, ...)
    return(rotated.theme)
  }
}
