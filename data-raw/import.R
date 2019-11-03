# library(magrittr)

tmpdir <- tempdir()

# Unzip files  {{{

zip_files <- list.files(path = ".", pattern = "^.+\\.zip$")

for (zf in zip_files) {
  unzip(zf, exdir = paste(tmpdir, sub("^(\\d{4}).+$", "\\1", zf), sub("^\\d{4}-(.+)\\.zip$", "\\1", zf), sep = "/"))
}

# }}}

list.files(tmpdir, recursive = TRUE, pattern = "2019", full.names = T)


# import the 2019 hcpcs data
HCPCS_2019 <- data.table::fread(paste(tmpdir, "2019", "Alpha-Numeric-HCPCS-File", "HCPC2019_CONTR_ANWEB.txt", sep = "/"),
                                sep = "\n", skip = 8,
                                header = FALSE,
                                strip.white = FALSE)

HCPCS_2019[, HCPCS_CD                    := substr(V1, start =    1L, stop =    5L)]
HCPCS_2019[, HCPCS_SQNC_NUM              := substr(V1, start =    6L, stop =   10L)]
HCPCS_2019[, HCPCS_REC_IDENT_CD          := substr(V1, start =   11L, stop =   11L)]
HCPCS_2019[, HCPCS_LONG_DESC_TXT         := substr(V1, start =   12L, stop =   91L)]
HCPCS_2019[, HCPCS_SHRT_DESC_TXT         := substr(V1, start =   92L, stop =  119L)]
HCPCS_2019[, HCPCS_PRCNG_IND_CD          := substr(V1, start =  120L, stop =  121L)]
HCPCS_2019[, HCPCS_MLTPL_PRCNG_IND_CD    := substr(V1, start =  128L, stop =  128L)]
HCPCS_2019[, HCPCS_CIM_RFRNC_SECT_NUM    := substr(V1, start =  129L, stop =  134L)]
HCPCS_2019[, HCPCS_MCM_RFRNC_SECT_NUM    := substr(V1, start =  147L, stop =  154L)]
HCPCS_2019[, HCPCS_STATUTE_NUM           := substr(V1, start =  171L, stop =  180L)]
HCPCS_2019[, HCPCS_LAB_CRTFCTN_CD        := substr(V1, start =  181L, stop =  183L)]
HCPCS_2019[, HCPCS_XREF_CD               := substr(V1, start =  205L, stop =  209L)]
HCPCS_2019[, HCPCS_CVRG_CD               := substr(V1, start =  230L, stop =  230L)]
HCPCS_2019[, HCPCS_ASC_PMT_GRP_CD        := substr(V1, start =  231L, stop =  232L)]
HCPCS_2019[, HCPCS_ASC_PMT_GRP_EFCTV_DT  := substr(V1, start =  233L, stop =  240L)]
HCPCS_2019[, HCPCS_MOG_PMT_GRP_CD        := substr(V1, start =  241L, stop =  243L)]
HCPCS_2019[, HCPCS_MOG_PMT_PLCY_IND_CD   := substr(V1, start =  244L, stop =  244L)]
HCPCS_2019[, HCPCS_MOG_PMT_GRP_EFCTV_DT  := substr(V1, start =  245L, stop =  252L)]
HCPCS_2019[, HCPCS_PRCSG_NOTE_NUM        := substr(V1, start =  253L, stop =  256L)]
HCPCS_2019[, HCPCS_BETOS_CD              := substr(V1, start =  257L, stop =  259L)]
HCPCS_2019[, HCPCS_TYPE_SRVC_CD          := substr(V1, start =  261L, stop =  261L)]
HCPCS_2019[, HCPCS_ANSTHSA_BASE_UNIT_QTY := substr(V1, start =  266L, stop =  268L)]
HCPCS_2019[, HCPCS_CD_ADD_DT             := substr(V1, start =  269L, stop =  276L)]
HCPCS_2019[, HCPCS_ACTN_EFCTV_DT         := substr(V1, start =  277L, stop =  284L)]
HCPCS_2019[, HCPCS_TERMNTN_DT            := substr(V1, start =  285L, stop =  292L)]
HCPCS_2019[, HCPCS_ACTN_CD               := substr(V1, start =  293L, stop =  293L)]
HCPCS_2019[, V1                          := NULL]

HCPCS_2019
HCPCS_2019$V1[1]

head(HCPCS_2019, n = 2)
str(HCPCS_2019)


HCPCS_2019 <- as.data.frame(HCPCS_2019)
save(HCPCS_2019, file = "../data/HCPCS_2019.rda")
