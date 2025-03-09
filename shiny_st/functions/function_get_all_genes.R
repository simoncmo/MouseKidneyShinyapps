# Get features for ui
# This is used to generate gene name table to use on UI. Not directly called by app 
st_df = read_tsv('table/ST_shiny_plot_df_ident_varialbe_genes_12202021.tsv')

col_not_include = c('id', "Short_piece_ID", "orig.ident", "Age", "Sex", "tissue", "row", 
                    "col", "imagerow", "imagecol", "imagerow_range", "imagecol_range", 
                    "W3F_ratio_row", "W3F_ratio_col", "to_scale",'Age_sex')
ident_options = c('seurat_clusters','RCTD_cell_name') # To be replaced
feature_options = setdiff(names(st_df), union(col_not_include, ident_options)) %>% sort
write_tsv(data.frame(gene = feature_options),'table/feature_options.tsv')
