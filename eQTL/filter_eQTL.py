#!/usr/bin/python
# combine_eQTL.py
# Read eQTL file of the direct SNP file, record all the association
# Then find additional associations of LD SNPs and retain everything that did not have probe association yet

import sys
import getopt
import glob
from scipy import stats
#from autovivification import autovivification as AV

p_thres = 1.7*(10**(-7))

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

	

	#print "Probe_Id	Symbol	SNPID	pvalue	beta	R.squared	t.test	n.samples	FDR	relativePosition	TAGID"
	expression = readEQTL()

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


def readEQTL(): # expect sample(col)-gene(row) matrixes

	genes = {}
	inFile = open( "20160315_survivalSNP_cisEQTL.tsv" , 'r' )
	header = inFile.readline()
	print header.strip()

	for line in inFile:
		line.strip()
		fields = line.split( "\t" )	
		for i in range(7, 18):
			if float(fields[i]) <= p_thres:
				print line.strip()
				next

	inFile.close()

	inFile = open( "20160315_rs116341973_additional_cisEQTL.tsv" , 'r' )
	header = inFile.readline()
		#print "HI"

	for line in inFile:
		line.strip()
		fields = line.split( "\t" )	
		for i in range(7, 18):
			if float(fields[i]) <= p_thres:
				print  line.strip()
				next



if __name__ == "__main__":
	main( sys.argv[1:] )