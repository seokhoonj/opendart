#' Get unique corporate code data
#'
#' Get unique corporate code data
#'
#' @param path path to download
#' @return A coporate code `data.frame`
#'
#' @export
get_corp_code <- function(path) {
  url <- "https://opendart.fss.or.kr/api/corpCode.xml"
  params <- list(crtfc_key = get_api_key())
  if (missing(path))
    path <- tempdir();
  tmp_file <- tempfile()
  res <- request(url) |> req_url_query(!!!params) |>
    req_options(ssl_verifypeer = 0) |> req_perform(path = tmp_file)
  unzip_path <- unzip(zipfile = tmp_file, exdir = path)
  df <- read_xml(unzip_path)
  corp_code   <- xml_find_all(df, "//corp_code")   |> xml_text()
  corp_name   <- xml_find_all(df, "//corp_name")   |> xml_text()
  stock_code  <- xml_find_all(df, "//stock_code")  |> xml_text()
  modify_date <- xml_find_all(df, "//modify_date") |> xml_text()
  df <- data.frame(corp_code, corp_name, stock_code, modify_date)
  df[] <- lapply(df, trimws)
  df[] <- lapply(df, function(x) ifelse(x == "", NA, x))
  return(df)
}

#' Get corporate basic information
#'
#' Get corporate basic information.
#'
#' @param corp_code corporate code
#' @return A response `data.frame`
#'
#' @examples
#' # get information
#' \dontrun{
#' get_corp_info("00126380")}
#'
#' @export
get_corp_info <- function(corp_code) {
  api_url <- "company.json"
  return(url_fetch(api_url = api_url, corp_code = corp_code))
}
