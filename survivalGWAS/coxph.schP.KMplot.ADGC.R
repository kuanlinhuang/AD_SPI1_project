# coxph.schP.R by Kuan Huang at WashU
# get all schP value from running GWAS

#Dependences
library( survival)
library('ggfortify')
library(ggplot2)
library(survminer)
setwd("/Users/khuang/Box\ Sync/PhD/AD/Genome-wide\ survival\ project/GWAS/Cox_assumptions")

#Constants
phenoFileName= 'extract_22snps/FINAL_ADGC_COVAR_UNRELATED_pc_filtered_noNA_noMAYO_NBB_ROSMAP2.txt'
genoFileName = "extract_22snps/adgc_2014_combined_unrelated_cleaned_18382_22snps.raw"
outFile = "tables/adgc_SchP.txt"

#Read the phenotypes; the phenotype file record each sample's phenotype in a row, whereas one column represents one covariate
pheno = read.table( phenoFileName, head=T)

#Read the genotypes; the genotype file is a zipped version of the raw file output from plink recodeA option
geno = read.table( genoFileName, head=T)
geno = geno[,-grep("HET",colnames(geno))]
#Combine the data
data = merge( pheno, geno, by="IID")
snp.N = dim(geno)[2]
snp.names = names( geno)[7:snp.N]
data.aux = data[, 1:length(names(pheno))]
rm( pheno, geno)

#Analysis
#sink(outFile)
zph_p_table = vector("list")
for( s in snp.names ) {
  data.aux$snp = data[,s]
  # fit a coxph model; note that the age is age at onset for cases, age at last assessment for controls
  # phenotype is coded 2 for AD cases (the event in this analysis)
  m2=try( coxph( Surv( aaoaae, status==2)~snp + sex + pc1 + pc2 + pc3 + strata(cohort_by_num),
                 data=data.aux, subset=snp!=-9, na.action = na.omit ), silent=T )
  
  fit = survfit(Surv(aaoaae, status) ~ snp, data = data.aux)
  p = autoplot(fit,  conf.int = FALSE,censor.size = 1)#,
  p = p + theme_bw()
  p = p + xlim(50,120)
  p = p + labs( x="Age") #+ guide_legend(title ="dosage")
  p
  fn = paste("figures/ADGC",s,"survival.pdf",sep="_")
  ggsave(fn,height=5,useDingbat=F)
  
  if(class(m2) == "try-error") {
    str = sprintf( "%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e", s, NA, NA, NA, NA, NA, NA, NA, NA, NA)
    cat( str, "\n");
    next;
  }
  #         coef = summary( m2)$coefficients[1,1]
  #         exp_coef = summary( m2)$coefficients[1,2]
  # 		se_coef = summary( m2)$coefficients[1,3]
  #         z = summary( m2)$coefficients[1,4]
  #         p.value = summary( m2)$coefficients[1,5]
  #         exp_neg_coef = summary(m2)$conf.int[1,2]
  #         ci.low = summary(m2)$conf.int[1,3]
  #         ci.high = summary(m2)$conf.int[1,4]
  
  #obtain Schoenfeld residuals to assess the adequacy of the Cox proportion hazard model
  zph = cox.zph(m2)
  #Schoenfeld_P = zph$table[1,3]
  
  zph_ps = zph$table[,"p"]
  zph_p_table[[s]] = c(s,zph_ps)
  # set P value to R double min. if lower than the machine limit
  # if ( !is.na(p.value) & p.value == 0)
  #         p.value = .Machine$double.xmin
  #OUTPUT FILE FORMAT
  # str = sprintf( "%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e", s, coef, exp_coef, exp_neg_coef, se_coef, z, p.value, ci.low, ci.high, Schoenfeld_P)
  # cat( str, "\n");
}
zph_p_table_m = do.call(rbind,zph_p_table)
write.table(zph_p_table_m, quote=F, sep="\t", file = outFile, row.names = F)