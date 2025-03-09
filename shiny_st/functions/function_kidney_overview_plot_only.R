# function_k

# Section 3: Plot related  
# Expression range for feature plot
get_exprange_list = function(variable_df) apply(variable_df, 2, range) %>% as.data.frame %>% as.list()

# E. Choose Color
col_seurat_spatial10 <- c("#5E4FA2", "#378EBA", "#75C8A4", "#BEE5A0", "#F1F9A9", "#FEEDA2",
                          "#FDBE6F", "#F67B49", "#D8434D", "#9E0142")
add_kidney_celltype_colors = function(p, variables, plt_mode, col_cell_all, aes_mode = c('fill','color')){
  aes_mode = match.arg(aes_mode)
  # Set color
  if(plt_mode == 'feature'){
    exp_range = get_exprange_list(p$data[,variables, drop=F])
    p = p + if(aes_mode=='fill') scale_fill_gradientn(colors = c('black', col_seurat_spatial10[2:10]), limits = exp_range[[variables]])
    else scale_color_gradientn(colors = c('black', col_seurat_spatial10[2:10]), limits = exp_range[[variables]])
  }else{
    if(str_detect(variables,'RCTD_cell_name')){
      if(missing(col_cell_all)) stop('please provide cell color: col_cell_all')
      p = p + if(aes_mode=='fill') scale_fill_manual(values = col_cell_all)
      else scale_color_manual(values = col_cell_all)
    }
  }
  return(p)
}

# F. Plot space adjustment
gg_remove_spacing = function(p){
  p &theme(panel.spacing = unit(0, "lines"),
           plot.margin = margin(0,0,0,0,'cm')
  ) &
    scale_x_continuous(expand = c(0, 0)) &
    scale_y_continuous(expand = c(0, 0))
}