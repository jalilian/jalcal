
# jalcal: an R package to convert Jalaali and Gregorian calendar dates

<!-- badges: start -->

![R-CMD-check](https://github.com/jalilian/jalcal/actions/workflows/R-CMD-check.yaml/badge.svg)
![CRAN Downloads](https://cranlogs.r-pkg.org/badges/last-month/jalcal)
<!-- badges: end -->

## Overview

The Persian or Jalaali calendar, also called the Solar Hijri or Hijri
Shamsi calendar, is a 12-month system.

- It begins its count from the Hijra, which is July 19, 622 AD in the
  standard Gregorian calendar.

- The Persian New Year begins on Nowruz, the spring equinox. This means
  the start of the year is timed with the start of spring, as determined
  by astronomical observations.

- The first six months have 31 days each, the next five have 30 days,
  and the last month has 29 days in common years and 30 days in leap
  years. Each season consists of three consecutive months.

- The exact leap year determination also relies on the vernal equinox
  date and time. The calculations and conversions in this package are
  based on the work by Kazimierz M. Borkowski (1996) who used an
  analytical model of Earth’s motion to calculate equinoxes from AD 550
  to 3800 and identify leap years based on Tehran time.

- The Persian calendar is the official calandar in Iran and Afghanistan
  and is also used in parts of Tajikistan and Kurdistan, particularly
  among Persian- and Kurdish-speaking communities.

- Borkowski, K. M. (1996). The Persian calendar for 3000 years. *Earth,
  Moon, and Planets*, 74, 223–230.
  [doi:10.1007/BF00055188](https://doi.org/10.1007/BF00055188)

## Installation

To install the development version of `jalcal` from
[GitHub](https://github.com/jalilian/jalcal), use the
[remotes](https://CRAN.R-project.org/package=remotes) package:

``` r
# Install remotes if not already installed
install.packages("remotes")

# Install getsat from GitHub
remotes::install_github("jalilian/jalcal")
```

To install the package from
[CRAN](https://CRAN.R-project.org/package=jalcal), use the
`install.packages` command:

``` r
# install.packages('jalcal')
```

## Example 1: Convert Jalaali dates to Gregorian dates

To convert **Jalaali dates** (e.g., `1403-12-30` and `1404-01-01`) to
**Gregorian dates**, use:

``` r
library("jalcal")
dates <- jal2greg(year=c(1403, 1404), month=c(12, 1), day=c(30, 1))
print(dates)
#> [1] "2025-03-20" "2025-03-21"
```

## Example 2: Convert Gregorian dates to Jalaali dates

To convert **Gregorian dates** to **Jalaali dates**, use:

``` r
set.seed(14040101)
gdates <- sample(seq.Date(from = as.Date("561-01-01"), 
                                to = as.Date("3177-12-31"), by = "day"), 
                       size = 100)
jdates <- greg2jal(gdates)
cbind(gdates, jdates)
#>         gdates Year Month Day
#> 1   1313-04-15  692     1  26
#> 2   3046-03-21 2425     1   1
#> 3   1393-01-18  771    10  28
#> 4    708-10-16   87     7  24
#> 5   2329-02-14 1707    11  25
#> 6   2554-08-17 1933     5  26
#> 7   2038-12-14 1417     9  22
#> 8   2465-09-09 1844     6  18
#> 9    593-08-24  -28     6   2
#> 10  1801-08-13 1180     5  22
#> 11  2601-11-04 1980     8  13
#> 12  2303-07-09 1682     4  17
#> 13  2742-08-12 2121     5  21
#> 14  2698-12-13 2077     9  22
#> 15   598-07-22  -23     4  30
#> 16  1775-01-30 1153    11   9
#> 17   616-05-22   -5     2  32
#> 18  1502-06-22  881     3  31
#> 19  2796-03-27 2175     1   8
#> 20  3018-11-22 2397     8  31
#> 21  3098-06-19 2477     3  29
#> 22   876-04-14  255     1  25
#> 23  2899-08-13 2278     5  22
#> 24  3059-10-31 2438     8   9
#> 25   673-07-29   52     5   7
#> 26  1139-09-04  518     6  12
#> 27  1354-08-07  733     5  16
#> 28  2033-10-31 1412     8  10
#> 29  2503-07-07 1882     4  16
#> 30  2157-03-30 1536     1  10
#> 31  1690-01-09 1068    10  19
#> 32  2317-04-02 1696     1  13
#> 33  2479-10-07 1858     7  14
#> 34  2505-12-17 1884     9  26
#> 35  2917-05-02 2296     2  12
#> 36  2632-08-07 2011     5  16
#> 37  3058-08-25 2437     6   3
#> 38  2698-06-30 2077     4   9
#> 39   929-11-09  308     8  18
#> 40  1284-05-08  663     2  18
#> 41   799-01-09  177    10  19
#> 42  1097-04-26  476     2   6
#> 43   747-04-10  126     1  20
#> 44  3071-01-06 2449    10  16
#> 45  1654-12-14 1033     9  22
#> 46   730-03-17  108    12  26
#> 47  1071-10-11  450     7  19
#> 48  3063-01-12 2441    10  22
#> 49  1968-06-29 1347     4   8
#> 50  1154-10-27  533     8   5
#> 51  3025-05-24 2404     3   3
#> 52   887-08-02  266     5  10
#> 53   681-05-17   60     2  27
#> 54   583-11-10  -38     8  18
#> 55  2191-10-19 1570     7  26
#> 56  1309-12-30  688    10   9
#> 57  1159-08-09  538     5  17
#> 58   915-04-26  294     2   5
#> 59  2702-01-16 2080    10  26
#> 60  2391-03-12 1769    12  21
#> 61  2628-03-27 2007     1   7
#> 62  2862-12-31 2241    10  10
#> 63  1825-04-05 1204     1  16
#> 64  1996-02-13 1374    11  24
#> 65  1995-10-27 1374     8   5
#> 66  2170-03-22 1549     1   1
#> 67  2548-03-01 1926    12  11
#> 68  2198-02-06 1576    11  17
#> 69  2147-12-05 1526     9  14
#> 70  2009-03-24 1388     1   4
#> 71  1804-08-01 1183     5  10
#> 72  1319-05-29  698     3   8
#> 73  2695-12-11 2074     9  20
#> 74   766-12-08  145     9  17
#> 75  1330-10-26  709     8   4
#> 76   568-05-26  -53     3   5
#> 77  1855-09-30 1234     7   8
#> 78  2068-10-22 1447     7  30
#> 79  3165-06-19 2544     3  29
#> 80  3048-04-30 2427     2  11
#> 81  2699-09-28 2078     7   6
#> 82  2145-04-17 1524     1  28
#> 83  1869-03-10 1247    12  20
#> 84  2880-12-01 2259     9  10
#> 85  1260-02-25  638    12   5
#> 86  1201-10-30  580     8   8
#> 87   844-06-16  223     3  26
#> 88  1120-06-26  499     4   5
#> 89  2278-10-28 1657     8   6
#> 90  2374-03-12 1752    12  21
#> 91  2581-08-25 1960     6   3
#> 92  3080-01-21 2458    11   1
#> 93  3000-02-15 2378    11  26
#> 94  1069-01-04  447    10  14
#> 95  2070-12-19 1449     9  28
#> 96  1377-07-02  756     4  11
#> 97  2123-02-20 1501    12   1
#> 98  2407-12-14 1786     9  23
#> 99  2365-04-26 1744     2   6
#> 100 2329-04-17 1708     1  28
```
