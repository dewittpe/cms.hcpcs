# BETOS_TB

tmpdir <- tempdir()
unzip("2019-HCPCS-Record-Layout.zip", exdir = tmpdir)

list.files(tmpdir, full.name = TRUE)

BETOS_TB <- data.table::fread(file = paste0(tmpdir, "/HCPCS2019_recordlayout.txt"),
                              strip.white = FALSE,
                              sep = "\n",
                              header = FALSE)

BETOS_TB <- BETOS_TB[833:940, V1]
BETOS_TB <- sub("^\\s+", "", BETOS_TB)

# there are couple multiline definitions, append the second line to the first.
idx <- which(!grepl("=", BETOS_TB))

BETOS_TB[idx - 1] <- paste(BETOS_TB[idx - 1], BETOS_TB[idx])

BETOS_TB <- strsplit(BETOS_TB, split = "=")
BETOS_TB <- Filter(function(x) {length(x) > 1}, BETOS_TB)
BETOS_TB <- lapply(BETOS_TB, function(x) {sub("^\\s+", "", sub("\\s+$", "", x))})
BETOS_TB <- lapply(BETOS_TB, function(x) {data.frame(BETOS_CD = x[1], DESCRIPTION = x[2], stringsAsFactors = FALSE)})
BETOS_TB <- do.call(rbind, BETOS_TB)

BETOS_TB

save(BETOS_TB, file = "../data/BETOS_TB.rda")

