all: ../data/HCPCS_2019.rda ../data/BETOS_TB.rda ../data/CMS_TYPE_SRVC_TB.rda

../data/HCPCS_2019.rda : import.R
	R CMD BATCH --vanilla $<

../data/BETOS_TB.rda : BETOS_TB.R
	R CMD BATCH --vanilla $<

../data/CMS_TYPE_SRVC_TB.rda : CMS_TYPE_SRVC_TB.R
	R CMD BATCH --vanilla $<
