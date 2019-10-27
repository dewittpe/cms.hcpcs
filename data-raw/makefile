all: ../data/hcpcs_2019.rda

../data/hcpcs_2019.rda : import.R
	R CMD BATCH --vanilla $<
