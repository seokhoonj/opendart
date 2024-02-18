#' Set an open api key
#'
#' Set an open api key to use opendart.
#'
#' @description
#' Save opendart api key as an environment variable for the current session. \cr
#' To set it permanently, please add the following line to your .Renvrion file: \cr
#'
#' OPENDART_API_KEY="YOUR API KEY" \cr
#'
#'
#' Please open .Renviron file via following code. \cr
#'
#' #> usethis::edit_r_environ() \cr
#'
#' @param api_key A string specifying opendart api key
#' @return No return value.
#'
#' @export
set_api_key <- function(api_key) {
  Sys.setenv(OPENDART_API_KEY = api_key)
}

get_api_key <- function() {
  api_key <- Sys.getenv("OPENDART_API_KEY")
  if (api_key == "") {
    stop("Please code `usethis::edit_r_environ()` and provide your OPENDART_API_KEY='your-api-key' to .Renviron",
         call. = FALSE)
  }
  return(api_key)
}

#' @rdname set_api_key
#' @export
print_api_key <- function() {
  Sys.getenv("OPENDART_API_KEY")
}
