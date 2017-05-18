library(ggplot2)
library(reshape2)
library(plyr)

Naive<-read.table("/Users/benjaminfairfax/Documents/bfairfax/Documents/Science/Matrix_eQTL_analysis/Expression/Incubator_out/15421_probe_data/CD14_15421_414_170613.txt",header=TRUE,row.names=1)

Naive.pc<-prcomp(t(Naive),center=TRUE,scale.=TRUE)
Naive.pc2<-data.frame(Naive.pc$x[1:414,1:414])

geno<-read.table("/Users/benjaminfairfax/Documents/bfairfax/Documents/Science/Matrix_eQTL_analysis/Genotyping/vol2_vol3_maf0.04_matrix_170613.txt",header=TRUE,row.names=1)

geno2<-geno[rownames(geno)=="rs10838698",]

imputed<-read.table("spi1_to_use",header=TRUE,row.names=1)

# Correct allele coding direction in imputed file

imputed<-(imputed-2)*(-1)

colnames(imputed)<-gsub("X","",colnames(imputed))

imputed2<-imputed[,colnames(imputed)%in%colnames(genotype.data2)]
cov2<-cbind(Naive.pc2[,c(1:40)],t(imputed2[1,]))

# Make linear model for effect of genotype on SPI1 expression, regressing effect of 40PC

model1 <- glm(t(spi1.exp[1,]) ~t(genotype.data2[1,])+ cov2[,c(1:40)],family="gaussian")

# Same model, but incorporate rs1057233

model2 <- glm(t(spi1.exp[1,]) ~t(genotype.data2[1,])+ cov2[,c(1:41)],family="gaussian")

remodelled1<-t(spi1.exp[1,]) - rowSums(sapply(1:(40), function(i)model1$coefficients[i+2]*test.cov[,i]))
remodelled2<-t(spi1.exp[1,]) - rowSums(sapply(1:(41), function(i)model1$coefficients[i+2]*cov2[,i]))

# Make data frame to plot values:

geno2<-data.frame(t(genotype.data2))
spi1.to.plot<-data.frame(cbind(geno2,remodelled1,remodelled2))
colnames(spi1.to.plot)<-c("id","rs10838698","SPI1","SPI1.rs1057233")
spi1.to.plot<-data.frame(spi1.to.plot)

spi1.to.plot2<-melt(data.frame(spi1.to.plot),measure.vars=c("SPI1","SPI1.rs1057233"),id.vars=c("id","rs10838698"))
colnames(spi1.to.plot2)<-c("id","rs10838698","Adjusted","Expression")
spi1.to.plot2[,c("Adjusted")]<-ifelse(spi1.to.plot2[,c("Adjusted")]=="SPI1","Unadjusted","Adjusted")

# Plot for figure:

ggplot(spi1.to.plot2,aes(as.factor(rs10838698),Expression))+
	facet_wrap(~Adjusted)+
	geom_violin(trim=FALSE,aes(fill=as.character(rs10838698)),colour="grey80",width=1.2)+
	geom_jitter(colour="grey35",position=position_jitter(width=0.15),alpha=0.6,size=2.4)+
	scale_fill_brewer(palette="RdBu") +
	theme_bw()+scale_x_discrete("rs10838698")+
	scale_y_continuous("Relative SPI1 Expression (Log2)")

#Edit accordingly