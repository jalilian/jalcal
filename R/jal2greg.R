
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
#' jal2greg(c(1362, 1394), c(6, 3), c(17, 19))
#' 
jal2greg <- function(year, month, day, asDate=TRUE)
{
  ndates <- length(year)
  if (length(month) != ndates | length(day) != ndates)
    stop("year, month and day arguments must have the same length")
  
  if (ndates == 1)
  {
    gdate <- do.jal2greg(year, month, day)
    if (asDate)
    {
      return(as.Date(paste(gdate[1], gdate[2], gdate[3], sep="-")))
    } else{
      return(gdate)
    }        
  } else{
    gdates <- mapply(do.jal2greg, year, month, day, 
                    SIMPLIFY=TRUE, USE.NAMES=FALSE)
    if (asDate)
    {
      return(as.Date(paste(gdates[1, ], gdates[2, ], gdates[3, ], sep="-")))
    } else{
      return(t(gdates))
    }  
  }
}

#' Internal function for converting Jalali calendar date to Gregorian calendar date
#'
#' @param year An integer specifying Jalali year
#' @param month An integer specifying Jalali month
#' @param day An integer specifying Jalali day
#' @return An integer vector consisting of the corresponding Gregorian year, month and day
#' @author Abdollah Jalilian
#' @noRd
do.jal2greg <- function(year, month, day)
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
      
  if (month < 1 | month > 12)
    stop("month is outside the range 1-12")
  if (day < 1 | day > 31)
    stop("day is outside the range 1-31")

  # epoch of the Jalali calendar is 19 July 622 in the Gregorian calendar
  # this is 226899 days since epoch of the Gregorian calendar
  # very 8 years, a leap year in the Jalali calender is after 5 years

  # the number of days since the beginning of the Georgian calendar
  year <- year + 1595
  days <- -355668 +
    365 * year +
    8 * (year %/% 33) +
    (3 + (year %% 33)) %/% 4 +
    day
  if (month < 7)
  {
    days <- days + 31 * (month -1 )
  } else{
    days <- days + 186 + 30 * (month - 7)
  }

  # 400 years in Gregorian calendar is 146097 days
  gyear <-400 * (days %/% 146097)
  days <- days %% 146097

  # 100 years in Gregorian calendar is 36524 days
  if (days > 36524)
  {
    days <- days - 1
    gyear <- gyear + 100 * (days %/% 36524)
    days <- days %% 36524
    if (days >= 365)
      days <- days + 1
  }

  # 4 years in Gregorian calendar is 1461 days
  gyear <- gyear + 4 * (days %/% 1461)
  days <- days %% 1461
  if (days > 365)
  {
    gyear <- gyear + ((days - 1) %/% 365)
    days <- (days - 1) %% 365
  }
  gday <- days + 1

  gmd <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  if (isLeap(gyear))
    gmd[2] <- 29
  sal_a <- c(0, gmd)
  gmonth <- 0
  while (gmonth < 13 && gday > sal_a[gmonth + 1])
  {
    gday <- gday - sal_a[gmonth + 1]
    gmonth <- gmonth + 1
  }
  
  return(c(gyear, gmonth, gday))
}
