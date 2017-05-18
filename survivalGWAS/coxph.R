# coxph.r by Oscar Harari and Kuan Huang at WashU; Goate lab and Cruchaga lab
# example code for the CHARGE consortium to run the WashU analysis

#Dependences
library( survival)

#Parameters
args = commandArgs(trailingOnly=T);
section= args[1]
cat( 'START ', section, "\n");
#Constants
phenoFileName= '/scratch/klhuang/GWAS_GERAD_survival.v1/pheno.GERAD_cleaned.txt'
genoFileName = sprintf( "/scratch/klhuang/GWAS_GERAD_survival.v1/chunks/GERAD1KG_Mar2012_MAF002_section_%s.raw.gz", section );
outFile = sprintf( "/scratch/klhuang/GWAS_GERAD_survival.v1/results/aao.GERAD1KG_Mar2012_MAF002_section_%s.txt", section ); 

#Read the phenotypes; the phenotype file record each sample's phenotype in a row, whereas one column represents one covariate
     pheno = read.table( phenoFileName, head=T)

#Read the genotypes; the genotype file is a zipped version of the raw file output from plink recodeA option               
     geno = read.table( gzfile( genoFileName), head=T) 

#Combine the data
     data = merge( pheno, geno, by="FID")
     snp.N = dim(geno)[2]
     snp.names = names( geno)[7:snp.N]
     data.aux = data[, 1:length(names(pheno))]
     rm( pheno, geno)

#Analysis
    sink(outFile)
    for( s in snp.names ) {
        data.aux$snp = data[,s]
		# fit a coxph model; note that the age is age at onset for cases, age at last assessment for controls
		# phenotype is coded 2 for AD cases (the event in this analysis)
        m2=try( coxph( Surv( age, PHENOTYPE==2)~snp + strata(SEX) + PC1 + PC2 + PC3 + NAPOE4 + strata(InNS) + strata(InCHOP) + strata(InMiami),
              data=data.aux, subset=snp!=-9, na.action = na.omit ), silent=T )      
              
        if(class(m2) == "try-error") {   
              str = sprintf( "%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e", s, NA, NA, NA, NA, NA, NA, NA, NA, NA)                
              cat( str, "\n");
              next;
              }
        coef = summary( m2)$coefficients[1,1]
        exp_coef = summary( m2)$coefficients[1,2]
		se_coef = summary( m2)$coefficients[1,3]
        z = summary( m2)$coefficients[1,4]
        p.value = summary( m2)$coefficients[1,5]
        exp_neg_coef = summary(m2)$conf.int[1,2]
        ci.low = summary(m2)$conf.int[1,3]
        ci.high = summary(m2)$conf.int[1,4]
		 
		#obtain Schoenfeld residuals to assess the adequacy of the Cox proportion hazard model
		zph = cox.zph(m2)
		Schoenfeld_P = zph$table[1,3]
		 
        # set P value to R double min. if lower than the machine limit 
        if ( !is.na(p.value) & p.value == 0)
                p.value = .Machine$double.xmin
        #OUTPUT FILE FORMAT  
        str = sprintf( "%s\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e\t%e", s, coef, exp_coef, exp_neg_coef, se_coef, z, p.value, ci.low, ci.high, Schoenfeld_P)
        cat( str, "\n");
        }
    sink()

cat( 'END ', section, "\n");