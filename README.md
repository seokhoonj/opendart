# opendart

(in-development)

-   Download corporate information via DART system (Data Analysis, Retrieval and Transfer System) which is the repository of Korea's corporate filings

-   DART에 공시되고있는 공시보고서 원문, 정보 등을 OPEN API를 통해 활용할 수 있습니다.

<!-- badges: start -->

[![CRAN status](https://www.r-pkg.org/badges/version/opendart)](https://CRAN.R-project.org/package=opendart) [![R-CMD-check](https://github.com/seokhoonj/opendart/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/seokhoonj/opendart/actions/workflows/R-CMD-check.yaml)

<!-- badges: end -->

## Installation

``` r
# install dev version
devtools::install_github("seokhoonj/opendart")
```

## Pre-requisite

-   <https://opendart.fss.or.kr/uss/umt/EgovMberInsertView.do>에서 api key를 생성합니다.

-   다음 코드 `usethis::edit_r_environ()` 를 실행하여 .Renviron 파일을 열고, OPENDART_API_KEY="발급받은 키 값" 를 입력한 후 저장합니다.

-   다음 코드 `.rs.restartR()`를 실행하면 api key가 저장되고 함수를 활용하실 수 있습니다.

## Examples

### Corp code list

``` r
library(opendart)

# all corporate codes
corp_code_list <- get_corp_code()
head(corp_code_list)

# only for listed corporate codes
listed <- corp_code_list[!is.na(corp_code_list$stock_code),]
head(listed)
```

### Financial statements

-   Period argument for reprt_code

| Reporting Period         | reprt_code | period |
|:-------------------------|:-----------|:-------|
| 사업보고서 (Annual)      | 11011      | A      |
| 반기보고서 (Half Year)   | 11012      | H      |
| 분기보고서 (1st Quarter) | 11013      | Q1     |
| 분기보고서 (3rd Quarter) | 11014      | Q3     |

``` r
# financial statements for a single corporate code
fs_singl <- fnltt_singl_acnt(corp_code = "00126380", bsns_year = 2022, period = "A")
head(fs_singl)

# financial statements for corporate codes
fs_multi <- fnltt_multi_acnt(corp_code = c("00356370", "00126380"), bsns_year = 2022, period = "A")
head(fs_multi)

# financial statements for a single corporate code
fs_singl_all <- fnltt_singl_acnt_all(corp_code = "00126380", bsns_year = 2022, period = "A", fs_div = "CFS") # OFS: 개별, CFS: 연결
head(fs_singl_all)
```

### Financial indicators

-   Index argument for idx_cl_code

| Indicator                  | idx_cl_code | index |
|:---------------------------|:------------|:------|
| 수익성지표 (Profitability) | M210000     | P     |
| 안정성지표 (Stability)     | M220000     | S     |
| 성장성지표 (Growth)        | M230000     | G     |
| 활동성지표 (Activity)      | M240000     | A     |

``` r
# financial index for a single corporate code
fnltt_singl_indx(corp_code = "00126380", bsns_year = 2023, period = "Q3", index = "P")

# financial index for corporate codes
fnltt_cmpny_indx(corp_code = c("00356370", "00126380"), bsns_year = 2023, period = "Q3", index = "P")
```
