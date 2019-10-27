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
hcpcs_2019 <- data.table::fread(paste(tmpdir, "2019", "Alpha-Numeric-HCPCS-File", "HCPC2019_CONTR_ANWEB.txt", sep = "/"),
                                sep = "\n", skip = 8,
                                header = FALSE)

hcpcs_2019[, HCPCS_CD := substr(V1, start =1L, stop = 5L)]

hcpcs_2019

hcpcs_2019 <- as.data.frame(hcpcs_2019)
save(hcpcs_2019, file = "../data/hcpcs_2019.rda")
