##### plot_Barres_brain_cell_expression.R #####
# Kuan-lin Huang @ WashU 2016 July
# plot multi-cell type expression of designated genes in the Barres brain dataset

### dependencies ###
bdir = "/Users/khuang/Box\ Sync/PhD/AD/Genome-wide\ survival\ project/expressions/"
setwd(bdir)
source("/Users/khuang/bin/LIB_exp.R")
library(Hmisc)

## functions 

human_f = "TableS4-HumanMouseMasterFPKMList_formatted_human.txt"
mouse_f = "TableS4-HumanMouseMasterFPKMList_formatted_mouse.txt"

##### human file #####
human_exp = read.table(sep="\t", quote = "",header=F,file = human_f)
mouse_exp = read.table(sep="\t", quote = "",header=F,file = mouse_f)

gene = "SPI1"
plot_human = function(gene){
  t_matrix = t(human_exp)
  t_matrix_g = t_matrix[,c(2:5,which(t_matrix[1,]==gene))]
  colnames(t_matrix_g) = c("Species","Cell","Sample","Gender","Expression")
  t_matrix_g = as.data.frame(t_matrix_g[-1,])
  t_matrix_g$Cell = capitalize(as.character(t_matrix_g$Cell))
  t_matrix_g$Expression = as.numeric(as.character(t_matrix_g$Expression))
  
  fn = paste(pd, gene, 'human_exp.pdf',sep ="_")
  p = ggplot(data=t_matrix_g,aes(x=Cell, y=Expression, fill=Cell))
  p = p + geom_point(size=0.5) 
  p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
  p = p + expand_limits(y = 0)
  p = p + theme_nogrid() + guides(fill=F)
  p = p + labs(x="",y = "Expression (FPKM)")
  p = p + theme(axis.title = element_text(size=10), axis.text.x = element_text(colour="black", size=8, angle=90, vjust = 0.5,hjust=1), axis.text.y = element_text(colour="black", size=8),axis.ticks = element_blank())#element_text(colour="black", size=14))
  p
  ggsave(file=fn, width = 3, height = 4, useDingbats=FALSE)
}

gene = "Sfpi1"
plot_mouse = function(gene){
  t_matrix = t(mouse_exp)
  t_matrix_g = t_matrix[,c(2:4,which(t_matrix[1,]==gene))]
  colnames(t_matrix_g) = c("Species","Cell","Sample","Expression")
  t_matrix_g = as.data.frame(t_matrix_g[-1,])
  t_matrix_g$Expression = as.numeric(as.character(t_matrix_g$Expression))
  t_matrix_g$Cell = capitalize(as.character(t_matrix_g$Cell))
  t_matrix_g$Cell[t_matrix_g$Cell %in% c("astrocytes-FACS","Astrocytes-immunopanned")] = "Astrocytes"
  
  fn = paste(pd, gene, 'mouse_exp.pdf',sep ="_")
  p = ggplot(data=t_matrix_g,aes(x=Cell, y=Expression, fill=Cell))
  p = p + geom_point(size=0.5) 
  p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
  p = p + expand_limits(y = 0)
  p = p + theme_nogrid() + guides(fill=F)
  p = p + labs(x="",y = "Expression (FPKM)")
  p = p + theme(axis.title = element_text(size=12), axis.text.x = element_text(colour="black", size=10, angle=90, vjust = 0.5,hjust=1), axis.text.y = element_text(colour="black", size=10),axis.ticks = element_blank())#element_text(colour="black", size=14))
  p = p + coord_flip()
  p
  ggsave(file=fn, width = 3, height = 4, useDingbats=FALSE)
}

##### main #####
# plot SPI1 and Spfi1


plot_human = function(gene){
  t_matrix = t(human_exp)
  t_matrix_g = t_matrix[,c(2:5,which(t_matrix[1,]==gene))]
  colnames(t_matrix_g) = c("Species","Cell","Sample","Gender","Expression")
  t_matrix_g = as.data.frame(t_matrix_g[-1,])
  t_matrix_g$Cell = capitalize(as.character(t_matrix_g$Cell))
  t_matrix_g$Expression = as.numeric(as.character(t_matrix_g$Expression))
  
  fn = paste(pd, gene, 'human_exp.pdf',sep ="_")
  p = ggplot(data=t_matrix_g,aes(x=Cell, y=Expression, fill=Cell))
  p = p + geom_point(size=0.5) 
  p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
  p = p + expand_limits(y = 0)
  p = p + theme_nogrid() + guides(fill=F)
  p = p + labs(x="",y = "Expression (FPKM)")
  p = p + theme(axis.title = element_text(size=10), axis.text.x = element_text(colour="black", size=8, angle=90, vjust = 0.5,hjust=1), axis.text.y = element_text(colour="black", size=8),axis.ticks = element_blank())#element_text(colour="black", size=14))
  p = p + coord_flip()
  p
  ggsave(file=fn, width = 5, height = 2.5, useDingbats=FALSE)
}

gene = "Sfpi1"
plot_mouse = function(gene){
  t_matrix = t(mouse_exp)
  t_matrix_g = t_matrix[,c(2:4,which(t_matrix[1,]==gene))]
  colnames(t_matrix_g) = c("Species","Cell","Sample","Expression")
  t_matrix_g = as.data.frame(t_matrix_g[-1,])
  t_matrix_g$Expression = as.numeric(as.character(t_matrix_g$Expression))
  t_matrix_g$Cell = capitalize(as.character(t_matrix_g$Cell))
  t_matrix_g$Cell[t_matrix_g$Cell %in% c("astrocytes-FACS","Astrocytes-immunopanned")] = "Astrocytes"
  
  fn = paste(pd, gene, 'mouse_exp.pdf',sep ="_")
  p = ggplot(data=t_matrix_g,aes(x=Cell, y=Expression, fill=Cell))
  p = p + geom_point(size=0.5) 
  p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
  p = p + expand_limits(y = 0)
  p = p + theme_nogrid() + guides(fill=F)
  p = p + labs(x="",y = "Expression (FPKM)")
  p = p + theme(axis.title = element_text(size=12), axis.text.x = element_text(colour="black", size=10), axis.text.y = element_text(colour="black", size=10),axis.ticks.y = element_blank())#element_text(colour="black", size=14))
  p = p + coord_flip()
  p
  ggsave(file=fn, width = 5, height = 2, useDingbats=FALSE)
}
plot_human("SPI1")
plot_mouse("Sfpi1")

### plot both and all genes ###
human_genes = c("SPI1","MYBPC3","MS4A4A","MS4A6A","SELL")
mouse_genes = c("Sfpi1","Mybpc3","","Ms4a6d","Sell")

t_matrix = t(human_exp)
t_matrix_g = t_matrix[,c(2:5,which(t_matrix[1,] %in% human_genes))]
colnames(t_matrix_g) = t_matrix_g[1,]
t_matrix_g = as.data.frame(t_matrix_g[-1,])
colnames(t_matrix_g)[1:4] = c("Species","Cell","Sample","Gender")
t_matrix_g_m = melt(t_matrix_g,id.vars=c("Species","Cell","Sample","Gender"))
t_matrix_g_m$Cell = capitalize(as.character(t_matrix_g_m$Cell))
t_matrix_g_m$value = as.numeric(as.character(t_matrix_g_m$value))

fn = paste(pd, 'composite_human_exp.pdf',sep ="_")
p = ggplot(data=t_matrix_g_m,aes(x=Cell, y=value, fill=Cell))
p = p + facet_grid(variable~., scale = "free_y")
p = p + geom_point(size=0.5) 
p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
p = p + expand_limits(y = 0)
p = p + theme_nogrid() + guides(fill=F)
p = p + labs(x="",y = "Expression (FPKM)")
p = p + theme(axis.title = element_text(size=10), axis.text.x = element_text(colour="black", size=8, angle=90, vjust = 0.5,hjust=1), axis.text.y = element_text(colour="black", size=8),axis.ticks = element_blank())#element_text(colour="black", size=14))
p
ggsave(file=fn, width = 3, height = 10, useDingbats=FALSE)


t_matrix = t(human_exp)
t_matrix_g = t_matrix[,c(2:5,which(t_matrix[1,] %in% human_genes))]
colnames(t_matrix_g) = t_matrix_g[1,]
t_matrix_g = as.data.frame(t_matrix_g[-1,])
colnames(t_matrix_g)[1:4] = c("Species","Cell","Sample","Gender")
t_matrix_g_m = melt(t_matrix_g,id.vars=c("Species","Cell","Sample","Gender"))
t_matrix_g_m$Cell = capitalize(as.character(t_matrix_g_m$Cell))
t_matrix_g_m$value = as.numeric(as.character(t_matrix_g_m$value))


t_matrix = t(mouse_exp)
t_matrix_g = t_matrix[,c(2:4,which(t_matrix[1,] %in% mouse_genes))]
colnames(t_matrix_g) = t_matrix_g[1,]
t_matrix_g = as.data.frame(t_matrix_g[-1,])
colnames(t_matrix_g)[1:3] = c("Species","Cell","Sample")
t_matrix_g_m = melt(t_matrix_g,id.vars=c("Species","Cell","Sample"))
t_matrix_g_m$value = as.numeric(as.character(t_matrix_g_m$value))
t_matrix_g_m$Cell = capitalize(as.character(t_matrix_g_m$Cell))
t_matrix_g_m$Cell[t_matrix_g_m$Cell %in% c("astrocytes-FACS","Astrocytes-immunopanned")] = "Astrocytes"

fn = paste(pd, 'composite_mouse_exp.pdf',sep ="_")
p = ggplot(data=t_matrix_g_m,aes(x=Cell, y=value, fill=Cell))
p = p + facet_grid(variable~., scale = "free_y")
p = p + geom_point(size=0.5) 
p = p + geom_boxplot(outlier.size = 0, alpha = 0.1)
p = p + expand_limits(y = 0)
p = p + theme_nogrid() + guides(fill=F)
p = p + labs(x="",y = "Expression (FPKM)")
p = p + theme(axis.title = element_text(size=10), axis.text.x = element_text(colour="black", size=8, angle=90, vjust = 0.5,hjust=1), axis.text.y = element_text(colour="black", size=8),axis.ticks = element_blank())#element_text(colour="black", size=14))
p
ggsave(file=fn, width = 2.5, height = 7, useDingbats=FALSE)
