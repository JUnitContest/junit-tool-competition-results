SHELL=/bin/bash

all: 
	Rscript Rscripts/analysis.R
	
clean: 
	rm -f plots/*.pdf