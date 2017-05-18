#!/usr/bin/python
# combine_eQTL.py
# Read eQTL file of the direct SNP file, record all the association
# Then find additional associations of LD SNPs and retain everything that did not have probe association yet

import sys
import getopt
import glob
from scipy import stats
#from autovivification import autovivification as AV

def main( argv ):

	helpText = "combine_eQTL.py\n\n\n"
	helpText += "USAGE:\npython combine_eQTL.py \n"

	inputFile = ""

	try:
		opts, args = getopt.getopt( argv , "h" )
		for opt, arg in opts:
			if opt in ( "-h" , "--help" ):
				print( helpText )
				sys.exit()
	except getopt.GetoptError:
		print "Command not recognized"
		print( helpText ) 
		sys.exit(2)

	print "Probe_Id	Symbol	SNPID	pvalue	beta	R.squared	t.test	n.samples	FDR	relativePosition	TAGID"
	expression = readEQTL( inputFile )


	# inFile = open( inputFile , 'r' )

	
	# header = inFile.readline()
	# print header.rstrip() + "\texpression_quantile" 
	# next(inFile)

	# try:
	# 	for line in inFile:
	# 		fields = line.split( "\t" )
	# 		gene = fields[geneColumn]
	# 		sample = fields[sampleColumn]
	# 		var_exp = "NA"
	# 		if expression[sample][gene]:
	# 			var_exp = expression[sample][gene]
	# except: 
	# 	print "can't annotate file" + inFile


def readGMT(): # expect sample(col)-gene(row) matrixes

	gene2path = {}
	inFile = open( "20160311_table1.cardiogenics_macrophages.txt" , 'r' )
	header = inFile.readline()
	#print header

	for line in inFile:
		line.strip()
		fields = line.split( "\t" )		
		gene = fields[0]
		snp = fields[2].strip()
		fields.append(snp)
		print '\t'.join([str(x).strip() for x in fields])
		genes[gene] = 1

	inFile.close()

	inFile = open( "20160315_macrophages_summary.tsv" , 'r' )
	header = inFile.readline()
		#print "HI"

	for line in inFile:
		fields = line.split( "\t" )		
		gene = fields[0]

		if gene in genes:
			next
		else:	
			print line.strip()

	return()


if __name__ == "__main__":
	main( sys.argv[1:] )