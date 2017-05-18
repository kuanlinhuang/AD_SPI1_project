# plot_forest.R by Kuan Huang @ WashU 201507
# VAF correlation plotting and analysis for WHIM manuscript figure 1

setwd("/Users/khuang/Box Sync/PhD/AD/Genome-wide survival project/GWAS/forest_plot")
source("/Users/khuang/bin/plotting_essentials.R")
library(forestplot)


fileNames = Sys.glob("*7cohorts.tsv")

for (fileName in fileNames) {
  snp = strsplit(fileName, split="_")[[1]][2]
  
  fn = "20160616_rs1057233_7cohorts.tsv"
  meta=read.table(file=fileName, header=TRUE, sep = "\t")
  
  # Cochrane data from the 'rmeta'-package
  IGAP_data = 
    structure(list(
      mean  = c(NA,meta$exp.coef.), 
      lower = c(NA,meta$CI.l),
      upper = c(NA,meta$CI.h)),
      .Names = c("mean", "lower", "upper"), 
      row.names = c(NA, meta$cohort), 
      class = "data.frame")
  
  tabletext<-cbind(
    c("Cohort", as.character(meta$cohort)),
    c("Hazard Ratio (95% CI)", paste(round(meta$exp.coef., 2), " (",round(meta$CI.l, 2),"-", round(meta$CI.h, 2),")",sep="")),
    c("P value",format.pval(meta$P,digits=2)))
  
  pdf(paste(pd,snp,'IGAP_forest.pdf', sep="_"), width=7, height=3.5,useDingbats=FALSE)
  forestplot(tabletext, 
             IGAP_data,
             is.summary=c(TRUE,rep(FALSE,length(meta$cohort))),
             clip=c(0.5,1.5), 
             xlog=TRUE, 
             title = snp
             #col=fpColors(box="royalblue",line="darkblue", summary="royalblue")
  )
  dev.off()
  
}