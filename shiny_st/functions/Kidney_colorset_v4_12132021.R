# Color palette for mouse kidney snRNA/ATAC and ST project
# v4 - 12/13/2021

col_cell_type = c("NP" = "#E41A1C",
"UBP" = "#377EB8",
"CS_NZS_mix" = "#4DAF4A",
"LOH_AL" = "#984EA3",
"NZS" = "#FF7F00",
"IM" = "#FFFF33",
"CS" = "#A65628",
"Endo" = "#F781BF",
"Podo" = "#999999",
"PT" = "#8DD3C7",
"unknown" = "#FFFFB3",
"MS" = "#BEBADA",
"Macro" = "#FB8072",
"CD_IC" = "#80B1D3",
"CNT" = "#FDB462",
"DCT" = "#B3DE69",
"Fib" = "#FCCDE5",
"T" = "#D9D9D9",
"CD_PC" = "#BC80BD",
"B/Plasma" = "#CCEBC5",
"Plasma/B" = "#CCEBC5",
'B-Plasma' = '#CCEBC5',
"PT(S3)" = "#1B9E77",
"PT(S1+S2)" = "#D95F02",
"LOH_DL" = "#7570B3",
"Proliferating" = "#E7298A",
"Uro" = "#66A61E",
'epithelial_aging_enriched' = '#13B7D9')

col_cell_type_dash = col_cell_type %>% setNames(names(.) %>% str_replace_all('_','-'))
col_cell_all = c(col_cell_type, c("epithelial_aging_enriched"='#bd38d1', "LOH_AL_Endo"='#5145a3', "PT_Endo_mix"='#225d8a'))

col_age = c("E165" = "#8DD3C7",
"P0" = "#FFFFB3",
"W1" = "#B3DE69",
"W2" = "#BC80BD",
"W3" = "#BEBADA",
"W12" = "#FB8072",
"W52" = "#80B1D3",
"W92" = "gray50", # Added temprarily 
"W113" = "#FDB462")

col_sex = c('M' = 'blue',
			'F' = 'red',
			'Male' = 'blue',
			'Female' = 'red')

col_platform = c('snATAC' = "#80c39b", 
	'snRNA' = "#85a8d0", 
	'ST' = "#f668b3")

# Spatial colors
col_10x_rainbow_short = c('#21171B', '#4F9DEE','#83F390','#DEDC56','#E56832', "#901818")
seurat_col_20 = c("#5E4FA2", "#466DB0", "#348BBB", "#50A9AF", "#6DC4A4", "#91D3A4", 
                  "#B4E0A2", "#D3ED9B", "#EBF7A0", "#F8FCB4", "#FEF6B1", "#FEE695", 
                  "#FDD07D", "#FDB567", "#F99655", "#F47346", "#E65948", "#D6404E", 
                  "#BA2148", "#9E0142")
col_seruat_st = c('black', seurat_col_20[5:20])