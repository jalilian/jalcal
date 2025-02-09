
# Borkowski, K. M. (1996). The Persian calendar for 3000 years. Earth, Moon, and Planets, 74, 223-230.

# This function determines if the Jalaali (Persian) year is
# leap (366-day long) or is the common year (365 days), and
# finds the day in March (Gregorian calendar) of the first
# day of the Jalaali year (Jy)
# Input: Jy - Jalaali calendar year (-61 to 3177)
# Output: A list containing:
#   leap - number of years since the last leap year (0 to 4)
#   Gy - Gregorian year of the beginning of Jalaali year
#   March - the March day of Farvardin the 1st (1st day of Jy)

jal_cal <- function(Jy)
{
  # Over 3,000 years, only about 20 years break the 33-year cycle for leap years
  # break years where the 33-year leap year cycle is interrupted
  breaks <- c(-61, 9, 38, 199, 426, 
              686, 756, 818, 1111, 1181, 
              1210, 1635, 2060, 2097, 2192, 
              2262, 2324, 2394, 2456, 3178)
  
  # check if Jy is within the valid range
  if (Jy < breaks[1] || Jy >= breaks[20]) 
  {
    stop("The algorithm is valid only for Jalaali years -61 to 3177")
  }
  
  # corresponding Gregorian year
  Gy <- Jy + 621   
  # initial leap year count
  leapJ <- -14     

  # find the last break year before Jy
  jp <- breaks[1]
  for (jm in breaks[-1])
  {
    jump <- jm - jp
    if (Jy < jm) 
      break
    leapJ <- leapJ + (jump %/% 33) * 8 + (jump %% 33) %/% 4
    jp <- jm
  }

  # years since last break year
  N <- Jy - jp
  
  # compute the number of leap years in Jalaali calendar
  leapJ <- leapJ + (N %/% 33) * 8 + ((N %% 33) + 3) %/% 4
  if (jump %% 33 == 4 && (jump - N) == 4) 
    leapJ <- leapJ + 1

  # compute the number of leap years in Gregorian calendar
  leapG <- floor(Gy / 4) - floor((Gy / 100 + 1) * 3 / 4) - 150
  
  # compute the first day of the Jalaali year in March
  March <- 20 + leapJ - leapG
  
  # Compute how many years have passed since the last leap year
  if (jump - N < 6) 
    N <- N - jump + ((jump + 4) %/% 33) * 33
  leap <- ((N + 1) %% 33 - 1) %% 4
  if (leap == -1) 
    leap <- 4
  
  # Return results as a named list
  return(list(leap = leap, Gy = Gy, March = March))
}

jal_to_greg <- function(Jy, Jm, Jd) 
{
  # Jy: Jalaali year
  # Jm: Jalaali month (1-12)
  # Jd: Jalaali day (1-31, 1-30, etc.)
  
  cal_info <- jal_cal(Jy)
  Gy <- cal_info$Gy
  March <- cal_info$March
  
  # days in each Jalaali month, handling leap year case
  days_in_month <- c(rep(31, 6), 
                     rep(30, 5), 
                     ifelse(cal_info$leap == 4, 30, 29))
  
  # compute the day-of-year in the Jalaali calendar
  jalaali_day_of_year <- Jd + 
    ifelse(Jm > 1, sum(days_in_month[1:(Jm - 1)]), 0)
  
  # Calculate day of year in Jalaali calendar
  if (Jm == 1)
    jalaali_day_of_year <- Jd
  else
    jalaali_day_of_year <- sum(days_in_month[1:(Jm - 1)]) + Jd
  
  # convert to Gregorian date
  Gregorian_date <- as.Date(paste(Gy, "03", March, sep="-")) + 
    jalaali_day_of_year - 1
  
  return(Gregorian_date)
}

greg_to_jal <- function(Gy, Gm, Gd) 
{
  # Gy: Gregorian year
  # Gm: Gregorian month (1-12)
  # Gd: Gregorian day (1-31, 1-30, etc.)
  
  # search for the Jalaali year
  Jy <- Gy - 621
  cal_info <- jal_cal(Jy)
  March <- cal_info$March
  Gregorian_date <- as.Date(paste(Gy, Gm, Gd, sep="-"))
  Jalaali_day_of_year <- as.numeric(Gregorian_date - 
                                      as.Date(paste(Gy, "03", March, sep="-"))) + 1
  
  if (Jalaali_day_of_year < 1)
  {
    Jy <- Jy - 1
    cal_info <- jal_cal(Jy)
    March <- cal_info$March
    Jalaali_day_of_year <- as.numeric(Gregorian_date - 
                                        as.Date(paste(Gy - 1, "03", March, sep="-"))) + 1
  }
  
  if(exists("March") == FALSE)
  {
    stop("Date out of range")
  }
  
  # days in each Jalaali month
  days_in_month <- c(rep(31, 6), 
                     rep(30, 5), 
                     ifelse(leap == 4, 30, 29))
  
  
  # find Jalaali month using `which.max`
  Jm <- which.max(cumsum(days_in_month) >= Jalaali_day_of_year)
  
  # compute Jalaali day
  Jd <- Jalaali_day_of_year - 
    ifelse(Jm > 1, sum(days_in_month[1:(Jm - 1)]), 0)
  
  return(list(Jy = Jy, Jm = Jm, Jd = Jd))
}

