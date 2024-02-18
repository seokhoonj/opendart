#' @description
#' Anyone can get information of the disclosure reports published on DART
#' through the open API.
#'
#' \itemize{
#' \item{DART disclosure statement}
#' \item{Key disclosures and financial information}
#' \item{Large amounts of financial information}
#' }
#'
#' @keywords internal
## usethis namespace: start
#' @importFrom cli style_hyperlink
#' @importFrom data.table rbindlist setDF
#' @importFrom httr2 req_body_json req_error req_headers req_options
#'  req_perform req_url_query request resp_body_json
#' @importFrom xml2 read_xml xml_find_all xml_text
#' @importFrom utils globalVariables head tail unzip
## usethis namespace: end
"_PACKAGE"
