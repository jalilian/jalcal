#' @name greg2jal0
#' @aliases greg2jal0
#'
#' @title Convert Gregorian calendar date to Jalali calendar date
#'
#' @param year An integer specifying Gregorian year
#' @param month An integer specifying Gregorian month
#' @param day An integer specifying Gregorian day
#' @return An integer vector consisting of the corresponding Jalali year, month and day
#' @author Abdollah Jalilian

#' @rdname greg2jal0
#' @export
#' @examples
#' greg2jal0(622, 3, 21)
#' greg2jal0(1983, 9, 8)
#'
greg2jal0 <- function(year, month, day)
{
  year <- as.integer(year)
  month <- as.integer(month)
  day <- as.integer(day)
  if (month < 1 | month > 12)
    stop("month is outside the range 1-12")
  if (day < 1 | day > 31)
    stop("day is outside the range 1-31")

  gdm <- c(0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334)
  year2 <- ifelse(month > 2, year + 1, year)
  days <- 355666 +
    365 * year +
    (3 + year2) %/% 4 -
    (year2 + 99) %/% 100 +
    (year2 + 399) %/% 400 +
    day +
    gdm[month]

  jyear <- -1595 + 33 * (days %/% 12053)
  days <- days %% 12053

  jyear <- jyear + 4 * (days %/% 1461)
  days <- days %% 1461
  if (days > 365)
  {
    jyear <- jyear + (days - 1) %/% 365
    days <- (days - 1) %% 365
  }

  if (days < 186)
  {
    jmonth <- 1 + (days %/% 31)
    jday <- 1 + days %% 31
  } else {
    jmonth <- 7 + (days - 186) %/% 30
    jday <- 1 + (days - 186) %% 30
  }

  return(c(jyear, jmonth, jday))
}

#' @name greg2jal
#' @aliases greg2jal
#'
#' @title Convert Gregorian calendar date to Jalali calendar date
#'
#' @param date An object of class Date specifying Gregorian date
#' @return An integer vector consisting of the corresponding Jalali year, month and day
#' @author Abdollah Jalilian
#' @rdname greg2jal
#' @export
#' @examples
#' greg2jal(base::Sys.Date())
#'
greg2jal <- function(date)
{
  if (!("Date" %in% class(date)))
    stop("date is not an object of class Date")
  date <- as.Date(date, format="%Y-%m-%d")
  date <- strsplit(as.character(date), split="-")[[1]]
  year <- as.integer(date[1])
  month <- as.integer(date[2])
  day <- as.integer(date[3])
  greg2jal0(year, month, day)
}
