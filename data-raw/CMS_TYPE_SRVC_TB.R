# CMS_TYPE_SRVC_TB

tmpdir <- tempdir()
unzip("2019-HCPCS-Record-Layout.zip", exdir = tmpdir)

list.files(tmpdir, full.name = TRUE)

CMS_TYPE_SRVC_TB <- data.table::fread(file = paste0(tmpdir, "/HCPCS2019_recordlayout.txt"),
                              strip.white = FALSE,
                              sep = "\n",
                              header = FALSE)

CMS_TYPE_SRVC_TB <- CMS_TYPE_SRVC_TB[946:995, V1]
CMS_TYPE_SRVC_TB <- sub("^\\s+", "", CMS_TYPE_SRVC_TB)

# there are couple multiline definitions, append the second line to the first.
idx <- which(!grepl("=", CMS_TYPE_SRVC_TB))

CMS_TYPE_SRVC_TB[idx - 1] <- paste(CMS_TYPE_SRVC_TB[idx - 1], CMS_TYPE_SRVC_TB[idx])

CMS_TYPE_SRVC_TB <- strsplit(CMS_TYPE_SRVC_TB, split = "=")
CMS_TYPE_SRVC_TB <- Filter(function(x) {length(x) > 1}, CMS_TYPE_SRVC_TB)
CMS_TYPE_SRVC_TB <- lapply(CMS_TYPE_SRVC_TB, function(x) {sub("^\\s+", "", sub("\\s+$", "", x))})
CMS_TYPE_SRVC_TB <- lapply(CMS_TYPE_SRVC_TB, function(x) {data.frame(CMS_TYPE_SRVC_CD = x[1], DESCRIPTION = x[2], stringsAsFactors = FALSE)})
CMS_TYPE_SRVC_TB <- do.call(rbind, CMS_TYPE_SRVC_TB)

CMS_TYPE_SRVC_TB

save(CMS_TYPE_SRVC_TB, file = "../data/CMS_TYPE_SRVC_TB.rda")

