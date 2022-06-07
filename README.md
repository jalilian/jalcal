[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/jalcal)](https://CRAN.R-project.org/package=jalcal)
[![CRAN_Download_Count](http://cranlogs.r-pkg.org/badges/jalcal)](https://CRAN.R-project.org/package=jalcal)
[![R Build Status](https://github.com/jalilian/jalcal/workflows/R-CMD-check/badge.svg)](https://github.com/jalilian/jalcal/actions)
[![License](https://eddelbuettel.github.io/badges/GPL2+.svg)](http://www.gnu.org/licenses/gpl-2.0.html)
[![Last Commit](https://img.shields.io/github/last-commit/jalilian/jalcal)](https://github.com/jalilian/jalcal)

# jalcal: an R package to convert Jalali and Gregorian calendar dates  

Jalali, also known as Persian, Solar Hijri and Hijri Shamsi calendar is the official calendar of Iran and Afghanistan. It begins on Nowruz, the March equinox, as determined by astronomical calculation and has years of 365 or 366 days. Adapting the algorithms in <https://jdf.scr.ir/>, this package provides tools for converting the Jalali and Gregorian dates.

## Installation

To install the package from [CRAN](https://CRAN.R-project.org/package=jalcal), run the following in R:
```R
install.packages('jalcal')
```

You can also install the current version of the package on GitHub by running:
```R
require(remotes)
install_github('jalilian/jalcal')
```

If [remotes](https://github.com/r-lib/remotes) is not installed, you should first run:

```R
install.packages('remotes')
```

## Usage

As examples of converting Jalali dates to Gregorian dates, simply run

```R
require('jalcal')
jal2greg(1, 1, 1)
jal2greg(1362, 6, 17)
jal2greg(1362, 6, 17, asDate=FALSE)
jal2greg(c(1362, 1394), c(6, 3), c(17, 19))
jal2greg(c(1362, 1394), c(6, 3), c(17, 19), asDate=FALSE)
```
Run the following as examples of converting Gregorian dates to Jalali dates
```R
greg2jal0(622, 3, 21)
greg2jal0(1983, 9, 8)
greg2jal0(c(1983, 2015), c(9, 6), c(8, 9))
greg2jal0(c(1983, 2015), c(9, 6), c(8, 9), asDate=TRUE)
greg2jal(base::Sys.Date())
```
