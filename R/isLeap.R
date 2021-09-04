#' Determining whether a given year is leap year
#'
#' @param year An integer vector specifying given years
#' @param cal A character string specifying the calender type. Only 'Gregorian' and 'Jalali' are implemented
#' @return A logical vector of of the same length as \code{year} which indicates wheter given years are leap years or not
#' @author Abdollah Jalilian
#' @export
#' @examples
#' isLeap(1362, 'Jalali')
#' isLeap(c(2000, 2100))
#'
isLeap <- function(year, cal='Gregorian')
{
  switch (cal,
          Gregorian = {
            cond1 <- year %% 4 == 0
            cond2 <- (year %% 100 == 0) & (year %% 400 != 0)
            ifelse(cond1 & !cond2, TRUE, FALSE)
          }, Jalali={
            rem <- year %% 33
            rem %in% c(1, 5, 9, 13, 17, 22, 26, 30)

          })
}
