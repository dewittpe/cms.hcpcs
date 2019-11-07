library(data.table)
library(rvest)
library(magrittr)

# Q4 2019 URLS
sessions <-
  list(
       "Evaluation and Management Services"  = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=99091-99499&sp=0"),
       "Anesthesia"                          = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=00100-01999&sp=0"),
       "Surgery"                             = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=10004-69990&sp=0"),
       "Radiology Procedures"                = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=70010-79999&sp=0"),
       "Pathology and Laboratory Procedures" = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=80047-89398&sp=0"),
       "Medicine Services and Procedures"    = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=90281-99607&sp=0"),
       "Category II Codes"                   = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=0001F-9007F&sp=0"),
       "Category III Codes"                  = html_session(url = "https://correctcodechek.decisionhealth.com/Cpt/Search.aspx?st=0&ss=Tabular&sk=0042T-0542T&sp=0")
       )


total_results <-
  lapply(sessions, read_html) %>%
  lapply(html_nodes, "span.totalResults") %>%
  lapply(html_text) %>%
  lapply(extract, 1) %>%
  lapply(sub, pattern = ".+\\s(\\d+)$", replacement = "\\1") %>%
  lapply(as.integer)

urls <-
  mapply(FUN = function(s, tr) {
           c(s$url, sapply(seq(1, tr %/% 50), function(x) {sub("sp=0", paste0("sp=", x), s$url)}))
         },
         s = sessions,
         tr = total_results)

get_codes <- function(url) {
  html_session(url) %>%
    read_html %>%
    html_nodes("div.result") %>%
    html_text() %>%
    gsub("\r\n", "", .) %>%
    sub("^\\s+", "", .) %>%
    sub("\\s+$", "", .) %>%
    strsplit(, split = "\\s{2,}") %>%
    lapply(., function(x) {data.table(HCPCS = x[1], DESCRIPTION = x[2])}) %>%
    rbindlist(.)
}

all_codes <- lapply(urls, function(x) {rbindlist(lapply(x, get_codes))})

HCPCS <- as.data.frame(rbindlist(all_codes, idcol = "GROUP"), stringsAsFactors = FALSE)
HCPCS$YEAR <- 2019L
HCPCS$QRT  <- 4L

save(HCPCS, file = "../data/HCPCS_CODES.rda")

