#!/usr/bin/python
# annotate_expression.py
# annotate expression of a variant based on its TCGA sample and gene name

import sys
import getopt
import glob
from scipy import stats
#from autovivification import autovivification as AV

def main( argv ):

	helpText = "summarize_eQTL.py\nAnnotate expression of a variant based on its TCGA sample and gene name.\n\n"
	helpText += "USAGE:\npython summarize_eQTL.py \n"

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
	expression = readEQTL("individual_snps_eQTL/*monocytes*")

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


def toFloat(x):
	try:
		float(x)
		return float(x)
	except:
		return "nan"

def readEQTL( inputFile ): # expect sample(col)-gene(row) matrixes
	try:
		#expression = AV({})
		genes = {}
		fileNames = glob.glob(inputFile)
		for fileName in fileNames:
			#print "Processing expression from file: " + fileName
			inFile = open( fileName , 'r' )
			header = inFile.readline()
			
			for line in inFile:
				#line.
				fields = line.split( "\t" )		
				gene = fields[0]
				if gene in genes:
					next
				else: 
					print line.rstrip()
					genes[gene] = 1


	except:
		print "bad expression file"

if __name__ == "__main__":
	main( sys.argv[1:] )