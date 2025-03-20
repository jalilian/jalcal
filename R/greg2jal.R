#' Convert Gregorian Dates to Jalaali (Persian) Calendar
#'
#' This function converts a vector of Gregorian dates (in `Date` format) to their
#' corresponding Jalaali (Persian) calendar dates. It correctly handles leap years
#' and determines the exact Jalaali year, month, and day for each input date.
#'
#' @param dates A vector of class `Date` representing the Gregorian dates to be converted.
#'
#' @return A data frame with three columns:
#' \item{Year}{The corresponding Jalaali year.}
#' \item{Month}{The corresponding Jalaali month.}
#' \item{Day}{The corresponding Jalaali day.}
#'
#' If a single date is provided, a numeric vector of length 3 (Year, Month, Day) is returned.
#'
#' @details
#' The Jalaali calendar is a solar calendar with an irregular leap year pattern. This function
#' follows an algorithm based on equinox calculations to accurately determine the Jalaali date
#' for each given Gregorian date.
#'
#' **Conversion Process:**
#' - The function first ensures that the input is of class `Date`.
#' - It estimates the Jalaali year by subtracting 621 from the Gregorian year.
#' - Leap year information for relevant Jalaali years is obtained using `jalLeap`.
#' - The function then determines the first day of the Jalaali year in the Gregorian calendar.
#' - Using cumulative day counts, it calculates the Jalaali month and day.
#' - If the input date falls before the start of the Jalaali year (before March 21), an adjustment
#'   is made to account for the previous year.
#'
#' The function efficiently handles both single and multiple date inputs, returning either a numeric
#' vector (for a single date) or a well-structured data frame.
#'
#' @examples
#' # Convert a single Gregorian date to Jalaali
#' greg2jal(as.Date("2024-03-21"))
#'
#' # Convert multiple dates
#' greg2jal(as.Date(c("2024-03-21", "2024-04-10", "2025-01-01")))
#'
#' @seealso
#' - \link[jalcal]{jalLeap} for computing leap year information.
#' - \link[jalcal]{jal2greg} for converting Jalaali dates to Gregorian dates
#'
#' @export
greg2jal <- function(dates)
{
  # check if the input is a Date object
  if (!inherits(dates, "Date"))
    stop("'dates' must be a Date object")

  # extract Gregorian years and estimate Jalaali years
  yearG <- as.integer(format(dates, "%Y"))
  yearJ <- yearG - 621

  # compute Jalaali leap year details and first day of each Jalaali year
  leap_info <- lapply(unique(yearJ), jalLeap)
  names(leap_info) <- unique(yearJ)

  # convert each date using vectorized operations
  out <- t(vapply(seq_along(dates), function(i) {
    yJ <- yearJ[i]
    lp <- leap_info[[as.character(yJ)]]
    firstJ <- as.Date(paste(lp$GregorianYear, "03", lp$MarchDay, sep="-"))
    df <- as.integer(dates[i] - firstJ)

    if (df == 0)
      return(c(yJ, 1, 1))

    if (df > 0)
    {
      # days in each Jalaali month
      month_days <- c(rep(31, 6), rep(30, 5), ifelse(lp$leap == 0, 30, 29))
      cum_days <- cumsum(month_days)

      # determine month and day
      monthJ <- which(df <= cum_days)[1]
      dayJ <- df - ifelse(monthJ > 1, cum_days[monthJ - 1], 0) + 1
    } else {
      # adjust for previous Jalaali year
      yJ <- yJ - 1
      lp2 <- leap_info[[as.character(yJ)]]
      if (is.null(lp2))
        lp2 <- jalLeap(yJ)
      month_days <- rev(c(30, 30, ifelse(lp2$leap == 0, 30, 29)))
      cum_days <- cumsum(month_days)

      idx <- which(-df <= cum_days)[1]
      monthJ <- 12 - idx + 1
      dayJ <- cum_days[idx] + df + 1
    }

    return(c(yJ, monthJ, dayJ))
  }, numeric(3)))

  # preare the output
  if (nrow(out) == 1)
  {
    out <- c(out)
  } else{
    out <- as.data.frame(out)
  }
  names(out) <- c("Year", "Month", "Day")

  return(out)
}

