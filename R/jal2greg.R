
#' Convert Jalali calendar date to Gregorian calendar date
#'
#' @param year An integer specifying Jalali year
#' @param month An integer specifying Jalali month
#' @param day An integer specifying Jalali day
#' @param asDate A logical flag indicating whether the output Gregorian date must be in date format
#' @return If \code{asDate = TRUE}, the default case, an object of the \code{Date} class in \code{R}, otherwise an integer vector consisting of the Gregorian year, month and day
#' @author Abdollah Jalilian
#' @export
#' @examples
#' jal2greg(1, 1, 1)
#' jal2greg(1362, 6, 17)
#' jal2greg(1362, 6, 17, asDate=FALSE)
#'
jal2greg <- function(year, month, day, asDate=TRUE)
{
  year <- as.integer(year)
  month <- as.integer(month)
  day <- as.integer(day)
  
  if (any(c(length(year), length(month), length(day)) == 0) | 
     any(!is.finite(c(year, month, day))))
  {
    if (asDate)
      return(NA)
    else
      return(rep(NA, 3))
  }
      
  if (any(month < 1 | month > 12))
    stop("month is outside the range 1-12")
  if (any(day < 1 | day > 31))
    stop("day is outside the range 1-31")

  # epoch of the Jalali calendar is 19 July 622 in the Gregorian calendar
  # this is 226899 days since epoch of the Gregorian calendar
  # every 8 years, a leap year in the Jalali calender is after 5 years

  # the number of days since the beginning of the Georgian calendar
  year <- year + 1595
  days <- -355668 +
    365 * year +
    8 * (year %/% 33) +
    (3 + (year %% 33)) %/% 4 +
    day
  days <- ifelse(month < 7, days + 31 * (month - 1),
                days + 186 + 30 * (month - 7))

  # 400 years in Gregorian calendar is 146097 days
  gyear <- 400 * (days %/% 146097)
  days <- days %% 146097

  # 100 years in Gregorian calendar is 36524 days
  idx <- days > 36524
  if (any(idx))
  {
    days[idx] <- days[idx] - 1
    gyear[idx] <- gyear[idx] + 100 * (days[idx] %/% 36524)
    days[idx] <- days[idx] %% 36524
    days[idx] <- ifelse(days[idx] >= 365, days[idx] + 1, days[idx])
  }

  # 4 years in Gregorian calendar is 1461 days
  gyear <- gyear + 4 * (days %/% 1461)
  days <- days %% 1461
  gyear <- ifelse(days > 365, gyear + ((days - 1) %/% 365, gyear))
  days <- ifelse(days > 365, days <- (days - 1) %% 365, days)
  gday <- days + 1

  gmfun <- function(gy, gd)
  {
    gmd <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
    if (isLeap(gy))
      gmd[2] <- 29
    sal_a <- c(0, gmd)
    gm <- 0
    while (gm < 13 && gd > sal_a[gm + 1])
    {
      gd <- gd - sal_a[gm + 1]
      gm <- gm + 1
    }
    return(c(gm, gd))
  }

  tmp <- mapply(gmfun, gyear, gday)
  gmonth <- tmp[, 1]
  gday <- tmp[, 2]
  if (asDate)
    out <- as.Date(paste(gyear, gmonth, gday, sep="-"))
  else
    out <- c(gyear, gmonth, gday)
  return(out)
}
