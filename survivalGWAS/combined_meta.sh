=======================================================================
						Combined Meta-analysis
=======================================================================
### run meta-analysis with each cohort independently ###
# Files to use:
ADGC:
/40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
/40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_APOE_conditioned/CoxPH_APOE_conditioned_whead_frq.auto.R

GERAD:
/home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
/home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_APOE_conditioned_country/CoxPH_APOE_conditioned_country_whead_frq.auto.R

EADI:
/40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_1percentMAF.txt
/40/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_1percentMAF.txt

/40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_apoe_1percentMAF.txt
/40/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_apoe_1percentMAF.txt


CHARGE:
/40/kuan/CHARGE_Cox/CHS_Cox_Age_Model1_2015-01-21.txt.maf_filtered_rsIDappended.txt
/40/kuan/CHARGE_Cox/FHS_Cox_Age_Model1_2014-12-16.txt.maf_filtered.txt
/40/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model1_2015-01-21.txt.maf_filtered.txt

/40/kuan/CHARGE_Cox/CHS_Cox_Age_Model2_2015-01-21.txt.maf_filtered_rsIDappended.txt
/40/kuan/CHARGE_Cox/FHS_Cox_Age_Model2_2014-12-16.txt.maf_filtered.txt
/40/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model2_2015-01-21.txt.maf_filtered.txt

### check A1 and A2 consistency ### 
#GERAD
$ grep1 rs34115518 /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
CHR	SNP	BP	A1	N	coef	exp_coef	se_coef	z	P	ci.low	ci.high A1_2 A2 MAF NCHROBS
   1   rs34115518    1150448    C 3614	-0.108417	0.897254	0.0539693	-2.00886	0.0445521	0.807191	0.997365	 C T 0.07795 8736
  
#ADGC 
$ grep1 rs34115518 /40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
CHR	SNP	BP	A1	N	coef	exp_coef	se_coef	z	P	ci.low	ci.high A1_2 A2 MAF NCHROBS
   1          rs34115518    1150448    C 17871	0.0179547	1.01812	0.0277629	0.646717	0.517815	0.964197	1.07505	 C T 0.08279 35742

#CHARGE 
## CHARGE results are consistent with each other, see CHARGE_CoxPH.sh
$ grep1 rs34115518 /40/kuan/CHARGE_Cox/CHS_Cox_Age_Model1_2015-01-21.txt.maf_filtered_rsIDappended.txt
SNP	CHR	BP	coef	exp(coef)	exp(-coef)	se(coef)	z-score	P	CI.l	CI.h	A1	A2	MAF	NCHROBS	Imputed
rs34115518	1	1150448	0.256388756397909	1.29225500270214	0.773841074640043	0.118591526107393	2.16194836860208	0.03062215615497871.02424282915963	1.63039754291359	C	T	0.0854182528723511	2049	0

#EADI
## EADI results are consistent with each other, see EADI_CoxPH.sh
# note that EADI A1 and A2 are switched from traditional plink format due to miscommunication
$ grep1 rs34115518 /40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_1percentMAF.txt
SNP	CHR	BP	coef	exp(coef)	exp(-coef)	se(coef)	z-score	P	CI.l	CI.h	Schoenfeld_P	A1	A2	MAF	NCHROBS	Info
rs34115518	1	1150448	0.03192239	1.032437	0.9685818	0.07237865	0.441047	0.659179	0.8958904	1.189796	0.6129295 T	C	0.07476588	2298	0.947

==== Meta-analysis ====
@ /40/kuan/META
### for model 1: without APOE conditioning
metal
# weighting effect size estimates by using the inverse of the corresponding standard errors
SCHEME STDERR
GENOMICCONTROL ON
AVERAGEFREQ ON
MINMAXFREQ ON
# === all cohorts ===
MARKER SNP
ALLELE A1_2 A2
EFFECT coef
PVALUE P
STDERR se_coef
FREQLABEL MAF
#ADGC
PROCESS /40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
#GERAD
PROCESS /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
#EADI
MARKER SNP
ALLELE A2 A1
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_1percentMAF.txt
PROCESS /40/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_1percentMAF.txt
#CHARGE
MARKER SNP
ALLELE A1 A2
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /40/kuan/CHARGE_Cox/CHS_Cox_Age_Model1_2015-01-21.txt.maf_filtered_rsIDappended.txt
PROCESS /40/kuan/CHARGE_Cox/FHS_Cox_Age_Model1_2014-12-16.txt.maf_filtered.txt
PROCESS /40/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model1_2015-01-21.txt.maf_filtered.txt

OUTFILE IGAP_meta .tbl
ANALYZE HETEROGENEITY

QUIT

$ wc -l IGAP_meta1.tbl
11222361 IGAP_meta1.tbl


### for model 2: with APOE conditioning
metal 
# weighting effect size estimates by using the inverse of the corresponding standard errors
SCHEME STDERR
GENOMICCONTROL ON
AVERAGEFREQ ON
MINMAXFREQ ON
# === all cohorts ===
MARKER SNP
ALLELE A1_2 A2
EFFECT coef
PVALUE P
STDERR se_coef
FREQLABEL MAF
#ADGC
PROCESS /40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_APOE_conditioned/CoxPH_APOE_conditioned_whead_frq.auto.R
#GERAD
PROCESS /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_APOE_conditioned_country/CoxPH_APOE_conditioned_country_whead_frq.auto.R
#EADI
MARKER SNP
ALLELE A2 A1
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_apoe_1percentMAF.txt
PROCESS /40/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_apoe_1percentMAF.txt
#CHARGE
MARKER SNP
ALLELE A1 A2
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /40/kuan/CHARGE_Cox/CHS_Cox_Age_Model2_2015-01-21.txt.maf_filtered_rsIDappended.txt
PROCESS /40/kuan/CHARGE_Cox/FHS_Cox_Age_Model2_2014-12-16.txt.maf_filtered.txt
PROCESS /40/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model2_2015-01-21.txt.maf_filtered.txt

OUTFILE IGAP_meta_apoe_conditioned .tbl
ANALYZE HETEROGENEITY

QUIT

$ wc -l IGAP_meta_apoe_conditioned1.tbl
11305885 IGAP_meta_apoe_conditioned1.tbl

### notes ###
# small number of duplicated variants in EADI files; negletible
# CHARGE files contain NA data; not processed by METAL
# note the indel IDs and alleles are not lining up, I can potentially go back to match on positions and snp names only; or use other strategies
# think about filter SNPs that appear in ?% of all samples, I can calculate this base on cohort size:
     21 # --> Input File 1 : /40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
     22 # --> Input File 2 : /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
     23 # --> Input File 3 : /40/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_1percentMAF.txt
     24 # --> Input File 4 : /40/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_1percentMAF.txt
     25 # --> Input File 5 : /40/kuan/CHARGE_Cox/CHS_Cox_Age_Model1_2015-01-21.txt.maf_filtered_rsIDappended.txt
     26 # --> Input File 6 : /40/kuan/CHARGE_Cox/FHS_Cox_Age_Model1_2014-12-16.txt.maf_filtered.txt
     27 # --> Input File 7 : /40/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model1_2015-01-21.txt.maf_filtered.txt

===Post-processing====
#change the header of the tbl files
for file in *tbl; do sed -i s/MarkerName/SNP/ $file; sed -i s/P-value/P/ $file;done

# attach positions
perl attach_pos.pl < IGAP_meta1.tbl > IGAP_meta1_pos.tbl
perl attach_pos.pl < IGAP_meta_apoe_conditioned1.tbl > IGAP_meta_apoe_conditioned1_pos.tbl

#qqman
nohup R --vanilla --args IGAP_meta1_pos.tbl coxPH_IGAP_meta < ~/bin/postProcessGwas.r &
nohup R --vanilla --args IGAP_meta_apoe_conditioned1_pos.tbl coxPH_IGAP_meta_apoe_conditioned < ~/bin/postProcessGwas.r &

nohup R --vanilla --args IGAP_meta1_pos_1filtered.txt coxPH_IGAP_meta_1filtered_minMAF002 0.02 < ~/bin/postProcessGwas_maf.r &
nohup R --vanilla --args IGAP_meta_apoe_conditioned1_pos_1filtered.tbl coxPH_IGAP_meta_apoe_conditioned_1filtered_minMAF002 0.02 < ~/bin/postProcessGwas_maf.r &





===analysis dropping FHS===
metal
# weighting effect size estimates by using the inverse of the corresponding standard errors
SCHEME STDERR
GENOMICCONTROL ON
AVERAGEFREQ ON
MINMAXFREQ ON
# === all cohorts ===
MARKER SNP
ALLELE A1_2 A2
EFFECT coef
PVALUE P
STDERR se_coef
FREQLABEL MAF
#ADGC
PROCESS /40/AD/GWAS_data/Combined_Plink/ADGC/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
#GERAD
PROCESS /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
#EADI
MARKER SNP
ALLELE A2 A1
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /home/huangk/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_1percentMAF.txt
PROCESS /home/huangk/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_1percentMAF.txt
#CHARGE
MARKER SNP
ALLELE A1 A2
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /home/huangk/kuan/CHARGE_Cox/CHS_Cox_Age_Model1_2015-01-21.txt.maf_filtered_rsIDappended.txt
#PROCESS /home/huangk/kuan/CHARGE_Cox/FHS_Cox_Age_Model1_2014-12-16.txt.maf_filtered.txt
PROCESS /home/huangk/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model1_2015-01-21.txt.maf_filtered.txt

OUTFILE IGAP_meta_no_FHS .tbl
ANALYZE HETEROGENEITY

QUIT

metal 
# weighting effect size estimates by using the inverse of the corresponding standard errors
SCHEME STDERR
GENOMICCONTROL ON
AVERAGEFREQ ON
MINMAXFREQ ON
# === all cohorts ===
MARKER SNP
ALLELE A1_2 A2
EFFECT coef
PVALUE P
STDERR se_coef
FREQLABEL MAF
#ADGC
PROCESS /40/AD/GWAS_data/Combined_Plink/ADGC/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_APOE_conditioned/CoxPH_APOE_conditioned_whead_frq.auto.R
#GERAD
PROCESS /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_APOE_conditioned_country/CoxPH_APOE_conditioned_country_whead_frq.auto.R
#EADI
MARKER SNP
ALLELE A2 A1
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /home/huangk/kuan/EADI_Cox/EADI_case_control_study_cox_sex_pcs_apoe_1percentMAF.txt
PROCESS /home/huangk/kuan/EADI_Cox/EADI_longitudinal_study_cox_sex_pcs_apoe_1percentMAF.txt
#CHARGE
MARKER SNP
ALLELE A1 A2
EFFECT coef
PVALUE P
STDERR se(coef)
FREQLABEL MAF
PROCESS /home/huangk/kuan/CHARGE_Cox/CHS_Cox_Age_Model2_2015-01-21.txt.maf_filtered_rsIDappended.txt
#PROCESS /home/huangk/kuan/CHARGE_Cox/FHS_Cox_Age_Model2_2014-12-16.txt.maf_filtered.txt
PROCESS /home/huangk/kuan/CHARGE_Cox/Rotterdam_Cox_Age_Model2_2015-01-21.txt.maf_filtered.txt

OUTFILE IGAP_meta_noFHS_apoe_conditioned .tbl
ANALYZE HETEROGENEITY

QUIT


###### I SHOULD MAKE SURE THE A1 AND A2 ANNOTATION ACROSS ALL FILES ARE CONSISTENT FIRST #######
###### THE EFFECT OF CHS IN CHARGE SEEM TO BE FLIPPED! ###################

===Post-processing====
#change the header of the tbl files
for file in *tbl; do sed -i s/MarkerName/SNP/ $file; sed -i s/P-value/P/ $file;done

# attach positions
perl attach_pos.pl < IGAP_meta_no_FHS1.tbl > IGAP_meta_no_FHS1_pos.tbl
perl attach_pos.pl < IGAP_meta_noFHS_apoe_conditioned1.tbl > IGAP_meta_noFHS_apoe_conditioned1_pos.tbl

#qqman

nohup R --vanilla --args IGAP_meta_no_FHS1_pos.tbl coxPH_IGAP_meta_noFHS < ~/bin/postProcessGwas.r &
nohup R --vanilla --args IGAP_meta_noFHS_apoe_conditioned1_pos.tbl coxPH_IGAP_meta_apoe_conditioned_noFHS < ~/bin/postProcessGwas.r &


========================second thought====================================
### run with consortium ###
# Files to use:
ADGC:
/40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_all/CoxPH_all_whead_frq.auto.R
/40/jake/adgc_2014_merged_cleaned/CPH_rplink/CoxPH_APOE_conditioned/CoxPH_APOE_conditioned_whead.auto.R

GERAD:
/home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
/home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_APOE_conditioned_country/CoxPH_APOE_conditioned_country_whead_frq.auto.R

EADI:
/40/kuan/EADI_Cox/coxPH_EADI_adjusted_1_pos.tbl
/40/kuan/EADI_Cox/coxPH_EADI_apoe_adjusted_1_pos.tbl

CHARGE:
/40/kuan/CHARGE_Cox/coxPH_CHARGE_model1_adjusted_1_pos.tbl
/40/kuan/CHARGE_Cox/coxPH_CHARGE_model2_adjusted_1_pos.tbl

# note the different number of markers between cohorts:
[huangk@ewok GERAD_610]$ wc -l CoxPH_APOE_conditioned_country_whead_frq.auto.R
4543687 CoxPH_APOE_conditioned_country_whead_frq.auto.R
[huangk@ewok CoxPH_all]$ wc -l CoxPH_all.auto.R
5013414 CoxPH_all.auto.R
[huangk@ewok CHARGE_Cox]$ wc -l coxPH_CHARGE_model1_adjusted_1_pos.tbl
9933791 coxPH_CHARGE_model1_adjusted_1_pos.tbl
[huangk@ewok EADI_Cox]$ wc -l coxPH_EADI_adjusted_1_pos.tbl
9252926 coxPH_EADI_adjusted_1_pos.tbl
### for the MAF cut-off in the whole data set; think about maybe taking SNPs in at least three cohorts? Or two.

# check the header A1 A2 annotations, if they match consistently between the four cohorts
# NOT -> write a script to flip strands to one standard set to ensure consistency
# flip to MAF <= 50% for CHARGE/EADI meta result

#GERAD
$ grep1 rs34115518 /home/huangk/GWAS/GERAD/survival/GERAD_610/CPH_rplink/CoxPH_all_country/CoxPH_all_country_whead_frq.auto.R
CHR	SNP	BP	A1	N	coef	exp_coef	se_coef	z	P	ci.low	ci.high A1_2 A2 MAF NCHROBS
   1   rs34115518    1150448    C 3614	-0.108417	0.897254	0.0539693	-2.00886	0.0445521	0.807191	0.997365	 C T 0.07795 8736
  
#ADGC 
[huangk@ewok CoxPH_all]$ grep1 rs34115518 CoxPH_all_whead_frq.auto.R  | awk '{print $1,$2,$3,$13,$14,$15}'
CHR SNP BP A1_2 A2 MAF
1 rs34115518 1150448 C T 0.08279
1 rs11721 1152631 A C 0.0764

#EADI 
[huangk@ewok EADI_Cox]$ grep -w rs34115518 coxPH_EADI_adjusted_1_pos.tbl
SNP	Allele1	Allele2	Effect	StdErr	P	Direction	HetISq	HetChiSq	HetDf	HetPVal	CHR	BP
rs34115518      t       c       0.0317  0.0644  0.6228  ++      0.0     0.000   1       0.9946  1       1150448
rs11721	a	c	-0.0069	0.0708	0.9224	--	0.0	0.002	1	0.9613	1	1152631

#CHARGE
[huangk@ewok ~]$ grep1 rs34115518 /40/kuan/CHARGE_Cox/coxPH_CHARGE_model1_adjusted_1_pos.tbl
SNP	Allele1	Allele2	Effect	StdErr	P	Direction	HetISq	HetChiSq	HetDf	HetPVal	CHR	BP
rs34115518	t	c	-0.0409	0.0715	0.5678	--+	87.7	16.216	2	0.0003011	1	1150448




