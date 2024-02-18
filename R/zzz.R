
.OPENDART_ENV <- NULL
.onLoad <- function(libname, pkgname){
  .OPENDART_ENV <<- new.env()
  assign(".OPENDART_BASE_URL", "https://opendart.fss.or.kr/api/", envir = .OPENDART_ENV)
}

.onAttach <- function(libname, pkgname) {
  packageStartupMessage(
    "Please get your open dart api key from the website ",
    cli::style_hyperlink(
      text = "https://opendart.fss.or.kr/",
      url = "https://opendart.fss.or.kr/"
    )
  )
}
