
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
  ndates <- length(date)
  year <- month <- day <- numeric(ndates)
  for (i in 1:ndates)
  {
    dt <- strsplit(as.character(date[i]), split="-")[[1]]
    year[i] <- as.integer(dt[1])
    month[i] <- as.integer(dt[2])
    day[i] <- as.integer(dt[3])
  }
  greg2jal0(year, month, day)
}

#' @name greg2jal0
#' @aliases greg2jal0
#'
#' @title Convert Gregorian calendar date to Jalali calendar date
#'
#' @param year An integer specifying Gregorian year
#' @param month An integer specifying Gregorian month
#' @param day An integer specifying Gregorian day
#' @param asDate A logical flag indicating whether the output Gregorian date must be in date format
#' @return If \code{asDate = TRUE}, an object of the \code{Date} class in \code{R}, otherwise an integer vector consisting of the Jalali year, month and day

#' @rdname greg2jal0
#' @export
#' @examples
#' greg2jal0(622, 3, 21)
#' greg2jal0(1983, 9, 8)
#' greg2jal0(c(1983, 2015), c(9, 6), c(8, 9))
#' greg2jal0(c(1983, 2015), c(9, 6), c(8, 9), asDate=TRUE)
#'
greg2jal0 <- function(year, month, day, asDate=FALSE)
{
  ndates <- length(year)
  if (length(month) != ndates | length(day) != ndates)
    stop("year, month and day arguments must have the same length")
  
  if (ndates == 1)
  {
    jdate <- do.greg2jal(year, month, day)
    if (asDate)
    {
      return(as.Date(paste(jdate[1], jdate[2], jdate[3], sep="-")))
    } else{
      return(jdate)
    }        
  } else{
    jdates <- mapply(do.greg2jal, year, month, day, 
                    SIMPLIFY=TRUE, USE.NAMES=FALSE)
    if (asDate)
    {
      return(as.Date(paste(jdates[1, ], jdates[2, ], jdates[3, ], sep="-")))
    } else{
      return(t(jdates))
    }
  }
}

#' @title Internal function for converting Gregorian calendar date to Jalali calendar date
#'
#' @param year An integer specifying Gregorian year
#' @param month An integer specifying Gregorian month
#' @param day An integer specifying Gregorian day
#' @return An integer vector consisting of the corresponding Jalali year, month and day
#' @author Abdollah Jalilian
#' @noRd
do.greg2jal <- function(year, month, day)
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
