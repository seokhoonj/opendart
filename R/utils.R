
get_base_url <- function() {
  return(local(.OPENDART_BASE_URL, envir = .OPENDART_ENV))
}

period_to_reprt_code <- function(period = c("A", "H", "Q1", "Q3")) {
  period <- match.arg(period)
  reprt_code <- switch(period,
                       A  = "11011",
                       H  = "11012",
                       Q1 = "11013",
                       Q3 = "11014")
  return(reprt_code)
}

index_to_idx_cl_code <- function(index = c("P", "S", "G", "A")) {
  index <- match.arg(index)
  idx_cl_code <- switch(index,
                        P = "M210000",
                        S = "M220000",
                        G = "M230000",
                        A = "M240000")
  return(idx_cl_code)
}

raise_error <- function(res) {
  if (res$status != "000") {
    stop(res$status, " ", res$message)
  }
}

paste_corp_code <- function(corp_code) {
  paste(corp_code, collapse = ",")
}

#' Fetch URL
#'
#' Fetch URL
#'
#' @param api_url url path after base url (`ex.` 'fnlttSinglAcnt.json')
#' @param ... request arguments \describe{
#' \itemize{
#'  \item{`corp_code`}
#'  \item{`bsns_year`}
#'  \item{`reprt_code`}
#'  \item{`idx_cl_code`}
#'  \item{`bgn_de`}
#'  \item{`end_de`}
#'  \item{`fs_div`}
#'  \item{`sj_div`}
#' }}
#' @return if not an error, A repsonse `data.frame`.
#'
#' @examples
#' # example code
#' \dontrun{
#' url_fetch(api_url = "fnlttSinglIndx.json", corp_code = "00126380",
#' bsns_year = 2023, reprt_code = "11014", idx_cl_code = "M210000")}
#'
url_fetch <- function(api_url, ...) {
  if (missing(api_url))
    stop("Please provide the api_url.")
  base_url <- get_base_url()
  url <- sprintf("%s%s", base_url = base_url, api_url = api_url)
  params <- list(crtfc_key = get_api_key())
  append_params <- list(...)
  params <- Filter(Negate(is.null), append(params, append_params))
  resp <- request(url) |> req_url_query(!!!params) |>
    req_options(ssl_verifypeer = 0) |> req_perform()
  res <- resp |> resp_body_json()
  if (res$status == "000") {
    if (!is.null(res$list)) {
      df <- data.table::rbindlist(res$list, fill = TRUE)
      data.table::setDF(df)
      return(df)
    } else {
      res$status <- NULL
      res$message <- NULL
      return(data.frame(res))
    }
  }
  raise_error(res)
}
