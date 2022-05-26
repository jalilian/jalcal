#' Convert Jalali calendar date to Gregorian calendar date
#'
#' @param year An integer specifying Jalali year
#' @param month An integer specifying Jalali month
#' @param day An integer specifying Jalali day
#' @param asDate A logical flag 
#'  indicating whether the output Gregorian date must be in date format
#' @return If \code{asDate = TRUE}, the default case, 
#'  an object of the \code{Date} class in \code{R}, 
#'  otherwise an integer vector consisting of the Gregorian year, month and day
#' @author Abdollah Jalilian
#' @export
#' @examples
#' jal2greg(1, 1, 1)
#' jal2greg(1362, 6, 17)
#' jal2greg(1362, 6, 17, asDate=FALSE)
#'
jal2greg <- function(year, month, day)
{
  #I removed the asDate argument because it will interfere with
  #the apply syntax in R; sometimes is will only display the days 
  #since the origin of Date format. 
  #The output can simply be transformed to Date using as.Date(). 

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
  
  if (sum(month < 1 | month > 12) != 0) {
    stop("a month is outside the range 1-12") }
  if (sum(day < 1 | day > 31) != 0) {
    stop("a day is outside the range 1-31") }
  
  # epoch of the Jalali calendar is 19 July 622 in the Gregorian calendar
  # this is 226899 days since epoch of the Gregorian calendar
  # very 8 years, a leap year in the Jalali calender is after 5 years
  
  # the number of days since the beginning of the Georgian calendar
  year <- year + 1595
  days <- -355668 +
    365 * year +
    8 * (year %/% 33) +
    (3 + (year %% 33)) %/% 4 + day
  days <- ifelse(month < 7, days + 31*(month -1), days + 186 + 30*(month - 7))
  
  # 400 years in Gregorian calendar is 146097 days
  gyear <-400 * (days %/% 146097)
  days <- days %% 146097
  
  # 100 years in Gregorian calendar is 36524 days
  
  gyear <- ifelse(days > 36524,gyear+100*(days%/%36524), gyear)
  days <- ifelse(days>36524,
                 ifelse(
                   (days-1)%%36524>=365,(((days-1)%%36524) + 1),((days-1)%%36524)),
                 days)

  # 4 years in Gregorian calendar is 1461 days
  gyear <- gyear + 4 * (days %/% 1461)
  days <- days %% 1461
  
  gyear <- ifelse(days > 365, gyear + ((days - 1) %/% 365), gyear)
  days  <- ifelse(days > 365, (days - 1) %% 365, days)
  
  gday <- days + 1
  
  gmd <- c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)
  
  gmd[2] <- ifelse(isLeap(gyear),29,28)

  sal_a <- c(0, gmd)
  gmonth <- 0
  
  while (gmonth < 13 && gday > sal_a[gmonth + 1])
  {
    gday <- gday - sal_a[gmonth + 1]
    gmonth <- gmonth + 1
  }
    out <- paste(gyear, gmonth, gday, sep="-")
    return(out)
}