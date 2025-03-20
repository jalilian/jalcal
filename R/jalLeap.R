#' Determine Leap Year and First Day of Jalaali Year
#'
#' Based on the work by Kazimierz M. Borkowski (1996), this function determines
#' whether a given Jalaali (Persian) year is a leap year and calculates the
#' corresponding Gregorian year and the day in March when the Jalaali New Year
#' (Nowruz) begins.
#'
#' @param yearJ An integer representing the Jalaali (Persian) year.
#'
#' @details
#' The Jalaali calendar is a solar calendar with an irregular leap year cycle,
#' designed to align closely with the vernal equinox. Unlike the Gregorian
#' calendar, which follows a fixed leap year rule, the Jalaali leap years are
#' determined by a more complex astronomical system:
#'
#' - A typical cycle lasts 33 years, with leap years occurring in years that
#'   leave a remainder of 1, 5, 9, 13, 17, 22, 26, or 30 when divided by 33.
#' - The cycle is occasionally disrupted by "break years," which adjust for
#'   small differences between the astronomical year and the calculated calendar.
#' - This function follows the leap year calculations and algorithm established by
#'   Kazimierz M. Borkowski (1996), who analysed equinox timings from AD 550 to
#'   3800.
#'
#' @return A named list with the following elements:
#' \item{leap}{An integer: 0 if the Jalaali year is a leap year and 1, 2 or 3
#' if the Jallai year is a common year.}
#' \item{GregorianYear}{The corresponding Gregorian year.}
#' \item{MarchDay}{The Gregorian calendar day in March when the Jalaali year starts.}
#'
#' @examples
#' # Check if 1403 is a leap year and get the start date of Nowruz
#' result <- jalLeap(1403)
#' print(result)
#'
#' @author Abdollah Jalilian
#'
#' @references
#' - Borkowski, K. M. (1996). The Persian calendar for 3000 years.
#'   *Earth, Moon, and Planets*, 74, 223–230.
#'   [doi:10.1007/BF00055188](https://doi.org/10.1007/BF00055188)
#'
#' @export
jalLeap <- function(yearJ)
{
  yearJ <- as.integer(yearJ)
  # break years, where the 33-year leap year cycle is interrupted
  breakYears <- c(-61, 9, 38, 199, 426,
                  686, 756, 818, 1111, 1181,
                  1210, 1635, 2060, 2097, 2192,
                  2262, 2324, 2394, 2456, 3178)

  # check if the given Jalaali year is within the valid range
  if ((yearJ < breakYears[1]) || (yearJ >= breakYears[length(breakYears)]))
    stop("The algorithm is valid only for Jalaali years between ",
         breakYears[1], " and ", breakYears[length(breakYears)], ".")

  # initialize leap year count in Jalaali calendar
  leapJalaali <- -14

  # find the last break year before the given Jalaali year
  lastBreakYear <- breakYears[1]
  for (breakYear in breakYears[-1])
  {
    yearsBetween <- breakYear - lastBreakYear
    if (yearJ < breakYear)
      break
    leapJalaali <- leapJalaali + (yearsBetween %/% 33) * 8 +
      (yearsBetween %% 33) %/% 4
    lastBreakYear <- breakYear
  }

  # calculate the years since the last break year
  yearsSinceBreak <- yearJ - lastBreakYear

  # compute the total number of leap years in the Jalaali calendar up to the given year
  leapJalaali <- leapJalaali + (yearsSinceBreak %/% 33) * 8 +
    ((yearsSinceBreak %% 33) + 3) %/% 4

  # special case handling for breaks in the cycle
  if (yearsBetween %% 33 == 4 && (yearsBetween - yearsSinceBreak) == 4)
    leapJalaali <- leapJalaali + 1

  # calculate corresponding Gregorian year
  gregorianYear <- yearJ + 621

  # compute the number of leap years in the Gregorian calendar
  leapGregorian <- floor(gregorianYear / 4) -
    floor((gregorianYear / 100 + 1) * 3 / 4) - 150

  # calculate the first day of the Jalaali year in the Gregorian calendar (March)
  marchDay <- 20 + leapJalaali - leapGregorian

  # calculate how many years have passed since the last leap year
  if (yearsBetween - yearsSinceBreak < 6)
    yearsSinceBreak <- yearsSinceBreak - yearsBetween + ((yearsBetween + 4) %/% 33) * 33
  leap <- ((yearsSinceBreak + 1) %% 33 - 1) %% 4
  if (leap == -1)
    leap <- 4

  # return the results as a named list
  return(list(leap = leap,
              GregorianYear = gregorianYear,
              MarchDay = marchDay))
}
