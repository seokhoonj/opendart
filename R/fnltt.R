#' Get financial accounts
#'
#' Get information of financial accounts. (2015 ~)
#'
#' @param corp_code unique corporate code (single or multi)
#' @param bsns_year business year
#' @param period period (A: Annual, H: Half year, Q1: 1st Quarter, Q3: 3rd Quarter)
#' @return if not an error, A repsonse `data.frame`.
#'
#' @examples
#' # get financial accounts (single corporate code)
#' \dontrun{
#' fnltt_singl_acnt(corp_code = "00126380", bsns_year = 2023, period = "A")}
#'
#' # get financial accounts (multiple corporate code)
#' \dontrun{
#' fnltt_multi_acnt(corp_code = c("00356370", "00126380"), bsns_year = 2023, period = "A")}
#'
#' @export
fnltt_singl_acnt <- function(corp_code, bsns_year,
                             period = c("A", "H", "Q1", "Q3")) {
  api_url <- "fnlttSinglAcnt.json"
  period <- match.arg(period)
  return(url_fetch(
    api_url = api_url,
    corp_code = corp_code,
    bsns_year = bsns_year,
    reprt_code = period_to_reprt_code(period)
  ))
}

#' @rdname fnltt_singl_acnt
#' @export
fnltt_multi_acnt <- function(corp_code, bsns_year,
                             period = c("A", "H", "Q1", "Q3")) {
  api_url <- "fnlttMultiAcnt.json"
  period <- match.arg(period)
  return(url_fetch(
    api_url = api_url,
    corp_code = paste_corp_code(corp_code),
    bsns_year = bsns_year,
    reprt_code = period_to_reprt_code(period)
  ))
}

#' Get financial accounts all
#'
#' Get information of financial accounts all. (2015 ~)
#'
#' @param corp_code unique corporate code
#' @param bsns_year business year
#' @param period period (A: Annual, H: Half year, Q1: 1st Quarter, Q3: 3rd Quarter)
#' @param fs_div type of financial statement (OFS: Original, CFS: Consolidated)
#' @return if not an error, A repsonse `data.frame`.
#'
#' @examples
#' # get financial accounts all (single corporate code)
#' \dontrun{
#' fnltt_singl_acnt_all(corp_code = "00126380", bsns_year = 2022, period = "A", fs_div = "CFS")}
#'
#' @export
fnltt_singl_acnt_all <- function(corp_code, bsns_year,
                                 period = c("A", "H", "Q1", "Q3"),
                                 fs_div = c("OFS", "CFS")) {
  api_url <- "fnlttSinglAcntAll.json"
  period <- match.arg(period)
  fs_div <- match.arg(fs_div)
  return(url_fetch(
    api_url = api_url,
    corp_code = corp_code,
    bsns_year = bsns_year,
    reprt_code = period_to_reprt_code(period),
    fs_div = fs_div
  ))
}

#' Get financial indicators
#'
#' Get financial indicators. (2023.3Q ~)
#'
#' @param corp_code unique corporate code (single or multi)
#' @param bsns_year business year
#' @param period period (A: Annual, H: Half year, Q1: 1st Quarter, Q3: 3rd Quarter)
#' @param index financial index (P: Profitability, S: Stability, G: Growth, A: Activity)
#' @return if not an error, A repsonse `data.frame`.
#'
#' @examples
#' # get financial indicators (single corporate code)
#' \dontrun{
#' fnltt_singl_indx(corp_code = "00126380", bsns_year = 2023, period = "A",
#' index = "P")}
#'
#' # get financial indicators (multiple corporate code)
#' \dontrun{
#' fnltt_cmpny_indx(corp_code = c("00356370", "00126380"), bsns_year = 2023,
#' period = "Q3", index = "P")}
#'
#' @export
fnltt_singl_indx <- function(corp_code, bsns_year,
                             period = c("A", "H", "Q1", "Q3"),
                             index = c("P", "S", "G", "A")) {
  api_url <- "fnlttSinglIndx.json"
  period <- match.arg(period)
  index <- match.arg(index)
  return(url_fetch(
    api_url = api_url,
    corp_code = corp_code,
    bsns_year = bsns_year,
    reprt_code = period_to_reprt_code(period),
    idx_cl_code = index_to_idx_cl_code(index)
  ))
}

#' @rdname fnltt_singl_indx
#' @export
fnltt_cmpny_indx <- function(corp_code, bsns_year,
                             period = c("A", "H", "Q1", "Q3"),
                             index = c("P", "S", "G", "A")) {
  api_url <- "fnlttCmpnyIndx.json"
  period <- match.arg(period)
  index <- match.arg(index)
  return(url_fetch(
    api_url = api_url,
    corp_code = paste_corp_code(corp_code),
    bsns_year = bsns_year,
    reprt_code = period_to_reprt_code(period),
    idx_cl_code = index_to_idx_cl_code(index)
  ))
}

#' Download original xbrl file of financial statements
#'
#' Download original xbrl file of financial statements.
#'
#' @param path path to download
#' @param rcept_no reception number
#' @param period period (A: Annual, H: Half year, Q1: 1st Quarter, Q3: 3rd Quarter)
#' @return A string specifying the file path.
#'
#' @examples
#' # download xbrl file
#' \dontrun{
#' fnltt_xbrl(rcept_no = "20190401004781", reprt_code = "11011")}
#'
#' @export
fnltt_xbrl <- function(path, rcept_no, period = c("A", "H", "Q1", "Q3")) {
  url <- "https://opendart.fss.or.kr/api/fnlttXbrl.xml"
  params <- list(
    crtfc_key = get_api_key(),
    rcept_no = rcept_no,
    reprt_no = period_to_reprt_code(period)
  )
  if (missing(path))
    path <- tempdir()
  tmp_file <- tempfile()
  resp <- request(url) |> req_url_query(!!!params) |>
    req_options(ssl_verifypeer = 0) |> req_perform(path = tmp_file)
  unzip_files <- unzip(zipfile = tmp_file, exdir = path)
  xbrl_files <- unzip_files[grepl("*.xbrl$", unzip_files)]
  if (length(xbrl_files) == 0)
    stop("xbrl file not found")
  return(xbrl_files)
}

#' Get XBRL taxonomy form
#'
#' Get XBRL taxonomy form.
#'
#' @param sj_div financial statement classification
#' @return A string specifying the file path.
#'
#' @examples
#' # get xbrl taxonomy form
#' \dontrun{
#' fnltt_xbrl(rcept_no = "20190401004781", reprt_code = "11011")}
#'
#' @export
get_xbrl_taxonomy <- function(sj_div) {
  api_url <- "xbrlTaxonomy.json"
  return(url_fetch(api_url, sj_div = sj_div))
}
