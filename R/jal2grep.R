#' Convert Jalaali (Persian) Calendar Date to Gregorian Calendar Date
#'
#' This function converts a date from the Jalaali (Persian) calendar to the
#' Gregorian calendar. It supports both single date conversions and vectorized
#' operations for multiple dates.
#'
#' @param year An integer or a vector of integers representing the Jalali year(s).
#' @param month An integer or a vector of integers representing the Jalali month(s) (1-12).
#' @param day An integer or a vector of integers representing the Jalali day(s) (1-31).
#'
#' @return A `Date` object or a vector of `Date` objects representing the
#' corresponding Gregorian date(s). If any input value is invalid, `NA` is
#' returned for that entry.
#'
#' @details
#' The function first verifies that the input values are valid Jalali dates,
#' ensuring that:
#' - The `year` values are finite integers.
#' - The `month` values range from 1 to 12.
#' - The `day` values are within valid ranges (1-31), considering month-specific limits.
#'
#' The conversion is performed in two steps:
#' 1. The function determines the Gregorian start date of the given Jalaali year
#'    using the `jalLeap()` function. This function provides the corresponding
#'    Gregorian year and the day in March when the Jalaali year begins.
#' 2. The exact Gregorian date is then calculated by adding the number of days
#'    elapsed since the start of the Jalaali year.
#'
#' @examples
#' # Convert a single Jalaali date to Gregorian
#' jal2greg(1402, 1, 1)
#'
#' # Convert multiple Jalaali dates to Gregorian
#' jal2greg(c(1403, 1404), c(12, 1), c(30, 1))
#'
#' @seealso
#' - \link[jalcal]{jalLeap} for computing leap year information.
#' - \link[jalcal]{greg2jal} for converting Jalaali dates to Gregorian dates
#'
#' @export
jal2greg <- function(year, month, day)
{
  # ensure inputs are integers
  year <- as.integer(year)
  month <- as.integer(month)
  day <- as.integer(day)

  # validate input lengths and finite values
  if (any(length(year) == 0, length(month) == 0, length(day) == 0) ||
      any(!is.finite(year), !is.finite(month), !is.finite(day)))
    return(rep(NA, max(length(year), length(month), length(day))))

  # Check valid month and day ranges
  stopifnot(all(month >= 1 & month <= 12), all(day >= 1 & day <= 31))

  # compute jalLeap results (assuming it returns a list with Gregorian year & March day)
  lp <- vapply(year, jalLeap, FUN.VALUE = vector("list", length = 3))

  # calculate the day offset within the Jalaali year
  dd <- 31 * (month - 1) - (month - 7) * (month >= 7) + day - 1

  # convert to Gregorian date
  out <- as.Date(paste0(lp["GregorianYear", ], "-03-", lp["MarchDay", ])) + dd
  return(out)
}
