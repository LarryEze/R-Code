' Dates and Times in R '

'
Dates and Times in R
Dates
Different conventions in different places
27th Feb 2013
- NZ: 27/2/2013
- USA: 2/27/2013

The global standard numeric date format
The global standard is called ISO 8601 i.e 2013-02-27

ISO 8601 YYYY-MM-DD
- Values ordered from the largest to smallest unit of time
- Each has a fixed number of digits, must be padded with leading zeros
- Either, no separators for computers, or '-' in dates
- 1st of January 2011 -> 2011-01-01

Dates in R
2003-02-27 -> in

1974 -> out

'2003-02-27' -> in

'2003-02-27' -> out

str('2003-02-27') -> in

chr '2003-02-27' -> out

as.Date('2003-02-27') -> in

'2003-02-27' -> out

str(as.Date('2003-02-27')) -> in

Date[1:1], format: '2003-02-27' -> out

- Packages that import dates: readr, anytime
'

# The date R 3.0.0 was released
x <- "2013-04-03"

# Examine structure of x
str(x)

# Use as.Date() to interpret x as a date
x_date <- as.Date(x)

# Examine structure of x_date
str(x_date)

# Store April 10 2014 as a Date
april_10_2014 <- as.Date('2014-04-10')


# Load the readr package
library(readr)

# Use read_csv() to import rversions.csv
releases <- read_csv('rversions.csv')

# Examine the structure of the date column
str(releases$date)

# Load the anytime package
library(anytime)

# Various ways of writing Sep 10 2009
sep_10_2009 <- c("September 10 2009", "2009-09-10", "10 Sep 2009", "09-10-2009")

# Use anytime() to parse sep_10_2009
anytime(sep_10_2009)


'
Why use dates?
Dates act like numbers
Date objects are stored as days since 1970-01-01

as.Date('2003-02-27') > as.Date('2002-02-27')  -> in

TRUE -> out

as.Date('2003-02-27') + 1 -> in

'2003-02-28' -> out

as.Date('2003-02-27') - as.Date('2002-02-27') -> in

Time difference of 365 days -> out

Plotting with dates
x<- c(as.Date('2003-02-27'), as.Date('2003-03-27'), as.Date('2003-04-27'))
plot(x, 1:3)

x<- c(as.Date('2003-02-27'), as.Date('2003-03-27'), as.Date('2003-04-27'))

library(ggplot2)
ggplot() + geom_point(aes(x=x, y=1:3))

R releases
releases is a data set that describes the release dates of all versions of R.
'

library(ggplot2)

# Set the x axis to the date column
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major)))

# Limit the axis to between 2010-01-01 and 2014-01-01
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major))) +
  xlim(as.Date('2010-01-01'), as.Date('2014-01-01'))

# Specify breaks every ten years and labels with "%Y"
ggplot(releases, aes(x = date, y = type)) +
  geom_line(aes(group = 1, color = factor(major))) +
  scale_x_date(date_breaks = "10 years", date_labels = "%Y")


# Find the largest date
last_release_date <- max(releases$date)

# Filter row for last release
last_release <- filter(releases, date == last_release_date)

# Print last_release
last_release

# How long since last release?
Sys.Date() - last_release_date


'
What about times?
ISO 8601
HH:MM:SS
- Largest unit to smallest
- Fixed digits
* Hours: 00 -- 24
* Minutes: 00 -- 59
* Seconds: 00 -- 60 (60 only for leap seconds)
- No separator or ':'

Datetimes in R
- Two objects types:
* POSIXlt - list with named components
* POSIXct - seconds since 1970-01-01 00:00:00
- POSIXct will go in a data frame
- as.POSIXct() turns a string into a POSIXct object

x <- as.POSIXct('1970-01-01 00:01:00')
str(x) -> in

POSIXct[1:1], format: '1970-01-01 00:01:00' -> out

Timezones
- '2013-02-27T18:00:00' - 6pm local time
- '2013-02-27T18:00:00Z' - 6pm UTC (Coordinated Universal Time), an international standard which doesn"t observe daylight savings.
- '2013-02-27T18:00:00-08:00' - 6pm in Oregon

as.POSIXct('2013-02-27T18:00:00Z') -> in

'2013-02-27 PST' -> out

as.POSIXct('2013-02-27T18:00:00Z', tz='UTC') -> in

'2013-02-27 UTC' -> out

Datetimes behave nicely too
once a POSIXct object, datetimes can be:
- Compared
- Subtracted
- Plotted
'

# Use as.POSIXct to enter the datetime 
as.POSIXct('2010-10-01 12:12:00')

# Use as.POSIXct again but set the timezone to `"America/Los_Angeles"`
as.POSIXct('2010-10-01 12:12:00', tz = 'America/Los_Angeles')

# Use read_csv to import rversions.csv
releases <- read_csv('rversions.csv')

# Examine structure of datetime column
str(releases$datetime)


# Import "cran-logs_2015-04-17.csv" with read_csv()
logs <- read_csv('cran-logs_2015-04-17.csv')

# Print logs
logs

# Store the release time as a POSIXct object
release_time <- as.POSIXct("2015-04-16 07:13:33", tz = "UTC")

# When is the first download of 3.2.0?
logs %>% 
  filter(datetime > release_time,
    r_version == "3.2.0")

# Examine histograms of downloads by version
ggplot(logs, aes(x = datetime)) +
  geom_histogram() +
  geom_vline(aes(xintercept = as.numeric(release_time)))+
  facet_wrap(~ r_version, ncol = 1)


'
Why lubridate?
lubridate
- Make working with dates and times in R easy!
- tidyverse package
* Plays nicely with builtin datetime objects
* Designed for humans not computers
- Plays nicely with other tidyverse packages
- Consistent behaviour regardless of underlying object

Parsing a wide range of formats
ymd('2013-02-27') -> in

'2013-02-27' -> out

dmy('27/2/13') -> in

'2013-02-27' -> out

parse_date_time(c('Feb 27th, 2017', '27th Feb 2017'), + order = c('mdy', 'dmy')) -> in

'2017-02-27 UTC' '2017-02-27 UTC' -> out

Manipulating datetimes
# Extract components
akl_daily <- akl_daily %>%
  mutate(year=year(date), yday=yday(date), month=month(date, label=TRUE))

Other lubridate features
- Handling timezones
- Fast parsing of standard formats
- Outputting datetimes
'


' Parsing and Manipulating Dates and Times with lubridate '

'
Parsing dates with lubridate
ymd()
- 27th of February 2013
- ymd() - year, then month, then day

ymd('2013-02-27') -> in

'2013-02-27' -> out

ymd('2013.02.27') -> in

'2013-02-27' -> out

ymd('2013 Feb 27th') -> in

'2013-02-27' -> out

Friends of ymd()
ymd(), ydm(), mdy(), myd(), dmy(), dym()

dmy('27-02-2013') -> in

'2013-02-27' -> out

mdy('02-27-2013')

'2013-02-27' -> out

dmy_hm('27-02-2013 12:12pm') -> in

'2013-02-27 12:12:00 UTC' -> out

parse_date_time(x=___, order=___)
parse_date_time(x='27-02-2013', order='dmy') -> in

'2013-02-27 UTC' -> out

parse_date_time(x=c('27-02-2013', '2013 Feb 27th'), order=c('dmy', 'ymd')) -> in

'2013-02-27 UTC' '2013-02-27 UTC' -> out

Formtting characters
Character   Meaning
d           Numeric day of the month
m           Month of year
y           Year with century
Y           Year without century
H           Hours (24 hour)
M           Minutes
S           Seconds
a           Abbreviated weekday
A           Full weekday
b           Abbreviate month name
B           Full month name
I           Hour (12 hour)
p           AM / PM
z           Timezone, offset from UTC
'

library(lubridate)

# Parse x 
x <- "2010 September 20th" # 2010-09-20
ymd(x)

# Parse y 
y <- "02.01.2010"  # 2010-01-02
dmy(y)

# Parse z 
z <- "Sep, 12th 2010 14:00"  # 2010-09-12T14:00
mdy_hm(z)


# Specify an order string to parse x
x <- "Monday June 1st 2010 at 4pm"
parse_date_time(x, orders = "ABdyIp")

# Specify order to include both "mdy" and "dmy"
two_orders <- c("October 7, 2001", "October 13, 2002", "April 13, 2003", "17 April 2005", "23 April 2017")
parse_date_time(two_orders, orders = c("Bdy", "Bdy", "Bdy", "dBy", "dBy"))

# Specify order to include "dOmY", "OmY" and "Y"
short_dates <- c("11 December 1282", "May 1372", "1253")
parse_date_time(short_dates, orders = c("dBy", "OmY", "Y"))


'
Weather in Auckland
make_date(year, month, day)
make_date(year=2013, month=2, day=27) -> in

'2013-02-27' -> out

make_datetime(year, month, day, hour, min, sec) for datetimes

dplyr Review
- mutate() - add new columns (or overwrite old ones)
- filter() - subset rows
- select() - subset columns
- arrange() - order rows
- summarise() - summarise rows
- group_by() - useful in conjuction with summarise()

Pipe %>%
# Without the pipe: nested functions
summarise(group_by(filter(releases, major == 3), minor), n = n())

# with pipe: more linear
releases %>%
  filter(major == 3) %>%
  group_by(minor) %>%
  summarise(n = n())
'

library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import CSV with read_csv()
akl_daily_raw <- read_csv('akl_weather_daily.csv')

# Print akl_daily_raw
akl_daily_raw

# Parse date 
akl_daily <- akl_daily_raw %>%
  mutate(date = as.Date(date))

# Print akl_daily
akl_daily

# Plot to check work
ggplot(akl_daily, aes(x = date, y = max_temp)) +
  geom_line() 


library(lubridate)
library(readr)
library(dplyr)
library(ggplot2)

# Import "akl_weather_hourly_2016.csv"
akl_hourly_raw <- read_csv('akl_weather_hourly_2016.csv')

# Print akl_hourly_raw
akl_hourly_raw

# Use make_date() to combine year, month and mday 
akl_hourly  <- akl_hourly_raw  %>% 
  mutate(date = make_date(year = year, month = month, day = mday))

# Parse datetime_string 
akl_hourly <- akl_hourly  %>% 
  mutate(
    datetime_string = paste(date, time, sep = "T"),
    datetime = ymd_hms(datetime_string)
  )

# Print date, time and datetime columns of akl_hourly
akl_hourly %>% select(date, time, datetime)

# Plot to check work
ggplot(akl_hourly, aes(x = datetime, y = temperature)) +
  geom_line()


'
Extracting parts of a datetime
x <- ymd('2013-02-23') 

year(x) -> in

2013 -> out

month(x) -> in

2 -> out

day(x) -> in

23 -> out

Extracting parts of a datetime
Function    Extracts
year()      Year with century
month()     Month (1 - 12)
day()       Day of month (1 - 31)
hour()      Hour (0 - 23)
min()       Minute (0 - 59)
second()    Second (0 - 59)
wday()      Weekday (1 - 7)
yday()      Day of year a.k.a. Julian day (1 - 366)
tz()        Timezone

Setting parts of a datetime
x -> in

'2013-02-23' -> out

year(x) <- 2017x -> in

'2017-02-23' -> out

Other useful functions
Function        Extracts
leap_year()     In leap year (TRUE or FALSE)
am()            In morning (TRUE or FALSE)
pm()            In afternoon (TRUE or FALSE)
dst()           During daylight savings (TRUE or FALSE)
quarter()       Quarter of year (1 - 4)
semester()      Half of year (1 - 2)

days_in_month: Get the number of days in the month of a date-time
days_in_month(x)
'

# Examine the head() of release_time
head(release_time)

# Examine the head() of the months of release_time
head(month(release_time))

# Extract the month of releases 
month(release_time) %>% table()

# Extract the year of releases
year(release_time) %>% table()

# How often is the hour before 12 (noon)?
mean(hour(release_time) < 12)

# How often is the release in am?
mean(am(release_time))


library(ggplot2)

# Use wday() to tabulate release by day of the week
wday(releases$datetime) %>% table()

# Add label = TRUE to make table more readable
wday(releases$datetime, label=TRUE) %>% table()

# Create column wday to hold labelled week days
releases$wday <- wday(releases$datetime, label=TRUE)

# Plot barchart of weekday by type of release
ggplot(releases, aes(wday)) +
  geom_bar() +
  facet_wrap(~ type, ncol = 1, scale = "free_y")


library(ggplot2)
library(dplyr)
library(ggridges)

# Add columns for year, yday and month
akl_daily <- akl_daily %>%
  mutate(
    year = year(date),
    yday = yday(date),
    month = month(date, label=TRUE))

# Plot max_temp by yday for all years
ggplot(akl_daily, aes(x = yday, y = max_temp)) +
  geom_line(aes(group = year), alpha = 0.5)

# Examine distribution of max_temp by month
ggplot(akl_daily, aes(x = max_temp, y = month, height = ..density..)) +
  geom_density_ridges(stat = "density")


# Create new columns hour, month and rainy
akl_hourly <- akl_hourly %>%
  mutate(
    hour = hour(datetime),
    month = month(datetime, label=TRUE),
    rainy = weather == "Precipitation"
  )

# Filter for hours between 8am and 10pm (inclusive)
akl_day <- akl_hourly %>% 
  filter(hour >= 8, hour <= 22)

# Summarise for each date if there is any rain
rainy_days <- akl_day %>% 
  group_by(month, date) %>%
  summarise(
    any_rain = any(rainy)
  )

# Summarise for each month, the number of days with rain
rainy_days %>% 
  summarise(
    days_rainy = sum(any_rain)
  )


'
Rounding datetimes
Rounding versus extracting
release_time <- releases$datetime
head(release_time) -> in

'1997-12-04 08:47:58 UTC' '1997-12-21 13:09:22 UTC'
'1998-01-10 00:31:55 UTC' '1998-03-14 19:25:55 UTC'
'1998-05-02 07:58:17 UTC' '1998-06-14 12:56:20 UTC' -> out

head(release_time) %>%
  hour() -> in

8 13 0 19 7 12 -> out

head(release_time) %>%
  floor_date(unit='hour') -> in

'1997-12-04 08:00:00 UTC' '1997-12-21 13:00:00 UTC'
'1998-01-10 00:00:00 UTC' '1998-03-14 19:00:00 UTC'
'1998-05-02 07:00:00 UTC' '1998-06-14 12:00:00 UTC' -> out

Rounding in lubridate
- round_date() - round to nearest
- ceiling_date() - round up
- floor_date() - round to down
- Possible values of unit:
* 'second', 'minute', 'hour', 'day', 'week', 'month', 'bimonth', 'quarter', 'halfyear' or 'year'
* Or multiples, e.g '2 years', '5 minutes'
'

r_3_4_1 <- ymd_hms("2016-05-03 07:13:28 UTC")

# Round down to day
floor_date(r_3_4_1, unit = 'day')

# Round to nearest 5 minutes
round_date(r_3_4_1, unit = '5 minutes')

# Round up to week 
ceiling_date(r_3_4_1, unit = 'week')

# Subtract r_3_4_1 rounded down to day
r_3_4_1 - floor_date(r_3_4_1, unit = 'day')


# Create day_hour, datetime rounded down to hour
akl_hourly <- akl_hourly %>%
  mutate(
    day_hour =floor_date(datetime, unit = 'hour')
  )

# Count observations per hour  
akl_hourly %>% 
  count(day_hour) 

# Find day_hours with n != 2  
akl_hourly %>% 
  count(day_hour) %>%
  filter(n != 2) %>% 
  arrange(desc(n))


' Arithmetic with Dates and Times '

'
Taking differences of datetimes
Arithmetic for datetimes
- datetime_1 - datetime_2 : Subtraction for time elapsed
- datetime_1 + (2 * timespan) : Addition and multiplication for generating new datetimes in the past or future
- timespan1 / timespan2 : Division for change of units

Subtraction of datetimes
releases <- read_csv('rversions.csv')
last_release <- filter(releases, date == max(date))

Sys.Date() - last_release$date -> in

Time difference of 99 days -> out

difftime(Sys.Date(), last_release$date) -> in

Time difference of 99 days -> out

time1 - time2 is the same as difftime(time1, time2)

difftime()
units = 'secs', 'mins', 'hours', 'days', 'weeks'

difftime(Sys.Date(), last_release$date, units='secs') -> in

Time difference of 8553600 secs -> out

difftime(Sys.Date(), last_release$date, units='weeks') -> in

Time difference of 14.14286 weeks -> out

now() and today()
today() -> in

'2017-01-07' -> out

str(today()) -> in

Date[1:1], format: '2017-10-07' -> out

now() -> in

'2017-10-07 09:44:52 PDT' -> out

str(now()) -> in

POSIXct[1:1], format: '2017-10-07 09:44:59' -> out
'

# The date of landing and moment of step
date_landing <- mdy("July 20, 1969")
moment_step <- mdy_hms("July 20, 1969, 02:56:15", tz = "UTC")

# How many days since the first man on the moon?
difftime(today(), date_landing, units = 'days')

# How many seconds since the first man on the moon?
difftime(now(), moment_step, units = 'secs')


# Three dates
mar_11 <- ymd_hms("2017-03-11 12:00:00", 
  tz = "America/Los_Angeles")
mar_12 <- ymd_hms("2017-03-12 12:00:00", 
  tz = "America/Los_Angeles")
mar_13 <- ymd_hms("2017-03-13 12:00:00", 
  tz = "America/Los_Angeles")

# Difference between mar_13 and mar_12 in seconds
difftime(mar_13, mar_12, units = 'secs')

# Difference between mar_12 and mar_11 in seconds
difftime(mar_12, mar_11, units = 'secs')


'
Time spans.
Time spans in lubridate
Period
- Human concept of a time span
- datetime + period of one day = same time on the next date
- Variable length

Duration
- Stopwatch concept of a time span
- datetime + duration of one day = datetime + 86400 seconds
- Fixed number of seconds

Creating a time span
days() -> in

'1d 0H 0M 0S' -> out

days(x = 2) -> in

'2d 0H 0M 0S' -> out

ddays(2) -> in

'172800s (~2 days)' -> out

Arithmetic with time spans
2 * days() -> in

'2d 0H 0M 0S' -> out

days() + days() -> in

'2d 0H 0M 0S' -> out

ymd('2011-01-01') + days() -> in

'2011-01-02' -> out 

Functions to create time spans
Time span   Duration    Period
Seconds     dseconds()  seconds()
Minutes     dminutes()  minutes()
Hours       dhours()    hours()
Days        ddays()     days()
Weeks       dweeks()    weeks()
Months                  months()
Years       dyears()    years()

unlike + and -, you might not get x back from x %m+% months(1) %m-% months(1). If you"d prefer that the date was rolled forward check out add_with_rollback() which has roll_to_first argument.
'

# Add a period of one week to mon_2pm
mon_2pm <- dmy_hm("27 Aug 2018 14:00")
mon_2pm + weeks(1)

# Add a duration of 81 hours to tue_9am
tue_9am <- dmy_hm("28 Aug 2018 9:00")
tue_9am + dhours(81)

# Subtract a period of five years from today()
today() - years(5)

# Subtract a duration of five years from today()
today() - dyears(5)


# Time of North American Eclipse 2017
eclipse_2017 <- ymd_hms("2017-08-21 18:26:40")

# Duration of 29 days, 12 hours, 44 mins and 3 secs
synodic <- ddays(29) + dhours(12) + dminutes(44) + dseconds(3)

# 223 synodic months
saros <- synodic * 223

# Add saros to eclipse_2017
saros + eclipse_2017


# Add a period of 8 hours to today
today_8am <- today() + hours(8)

# Sequence of two weeks from 1 to 26
every_two_weeks <- 1:26 * weeks(2)

# Create datetime for every two weeks for a year
every_two_weeks + today_8am


# A sequence of 1 to 12 periods of 1 month
month_seq <- 1:12 * months(1)

# Add 1 to 12 months to jan_31
jan_31 + month_seq

# Replace + with %m+%
jan_31 %m+% month_seq

# Replace + with %m-%
jan_31 %m-% month_seq


'
Intervals
Creating intervals
datetime1 %--% datetime2, or
interval(datetime1, datetime2)

dmy('5 January 1961') %--% dmy('30 January 1969') -> in

1961-01-05 UTC--1969-01-30 UTC -> out

interval(dmy('5 January 1961'), dmy('30 January 1969')) -> in

1961-01-05 UTC--1969-01-30 UTC -> out

Operating on an interval
beatles <- dmy('5 January 1961') %--% dmy('30 January 1969') 

int_start(beatles) -> in

1961-01-05 UTC -> out

int_end(beatles) -> in

1969-01-30 UTC -> out

int_length(beatles) -> in

254620800 -> out

as.period(beatles) -> in

'8y 0m 25d 0H 0M 0S' -> out

as.duration(beatles) -> in

'254620800s (~8.07 years)' -> out

Comparing intervals
hendrix_at_woodstock <- mdy('August 17 1969') 

hendrix_at_woodstock %within% beatles -> in

FALSE -> out

hendrix <- dmy('01 October 1966') %--% dmy('16 September 1970') 

int_overlaps(beatles, hendrix) -> in

TRUE -> out

Which kind of time span?
Use:
- Intervals 
* when you have a start and end datetime
* It is easily converted to either a period or duration.
- Periods
* When you are interested in human units
* e.g daylight savings, leap years
- Durations
* If more interested in seconds elapsed
'

# Print monarchs
monarchs 

# Create an interval for reign
monarchs <- monarchs %>%
  mutate(reign = from %--% to) 

# Find the length of reign, and arrange
monarchs %>%
  mutate(length = int_length(reign)) %>% 
  arrange(desc(length)) %>%
  select(name, length, dominion)


# Print halleys
halleys

# New column for interval from start to end date
halleys <- halleys %>% 
  mutate(visible = interval(start_date, end_date))

# The visitation of 1066
halleys_1066 <- halleys[14, ] 

# Monarchs in power on perihelion date
monarchs %>% 
  filter(halleys_1066$perihelion_date %within% reign) %>%
  select(name, from, to, dominion)

# Monarchs whose reign overlaps visible time
monarchs %>% 
  filter(int_overlaps(halleys_1066$visible, reign)) %>%
  select(name, from, to, dominion)


# New columns for duration and period
monarchs <- monarchs %>%
  mutate(
    duration = as.duration(reign),
    period = as.period(reign)) 
    
# Examine results    
monarchs %>%
  select(name, duration, period)


' Problems in practice '

'
Time zones
Sys.timezone() -> in # used to see the timezone of the laptop in R

'America/Los_Angeles' -> out

IANA Timezones
OlsonNames() -> in

'Africa/Abidjan' 'Africa/Accra'
'Africa/Addis_Ababa' 'Africa/Algiers'
'Africa/Asmara' 'Africa/Asmera'
'Africa/Bamako' 'Africa/Bangui'
... -> out

length(OlsonNames()) -> in

594 -> out

Setting and extracting
mar_qq <- ymd_hms('2017-03-11 12:00:00', tz = 'America/Los_Angeles')

mar_11 -> in

'2017-03-11 12:00:00 PST' -> out

tz(mar_11) -> in

'America/Los_Angeles' -> out

Manipulating timezones
force_tz() - change the timezone without changing the clock time

mar_11 -> in

'2017-03-11 12:00:00 PST' -> out

force_tz(mar_11, tzone = 'America/New_York') -> in

'2017-03-11 12:00:00 EST' -> out

with_tz() - view the same instant in a different timezone

mar_11 -> in

'2017-03-11 12:00:00 PST' -> out

with_tz(mar_11, tzone = 'America/New_York') -> in

'2017-03-11 15:00:00 EST' -> out
'

# Game2: CAN vs NZL in Edmonton
game2 <- mdy_hm("June 11 2015 19:00")

# Game3: CHN vs NZL in Winnipeg
game3 <- mdy_hm("June 15 2015 18:30")

# Set the timezone to "America/Edmonton"
game2_local <- force_tz(game2, tzone = 'America/Edmonton')
game2_local

# Set the timezone to "America/Winnipeg"
game3_local <- force_tz(game3, tzone = 'America/Winnipeg')
game3_local

# How long does the team have to rest?
as.period(game2_local %--% game3_local)


# What time is game2_local in NZ?
with_tz(game2_local, tzone = 'Pacific/Auckland')

# What time is game2_local in Corvallis, Oregon?
with_tz(game2_local, tzone = 'America/Los_Angeles')

# What time is game3_local in NZ?
with_tz(game3_local, tzone = 'Pacific/Auckland')


# Examine datetime and date_utc columns
head(akl_hourly$datetime)
head(akl_hourly$date_utc)
  
# Force datetime to Pacific/Auckland
akl_hourly <- akl_hourly %>%
  mutate(
    datetime = force_tz(datetime, tzone = 'Pacific/Auckland'))

# Reexamine datetime
head(akl_hourly$datetime)
  
# Are datetime and date_utc the same moments
table(akl_hourly$datetime - akl_hourly$date_utc)


# Import auckland hourly data 
akl_hourly <- read_csv('akl_weather_hourly_2016.csv')

# Examine structure of time column
str(akl_hourly$time)

# Examine head of time column
head(akl_hourly$time)

# A plot using just time
ggplot(akl_hourly, aes(x = time, y = temperature)) +
  geom_line(aes(group = make_date(year, month, mday)), alpha = 0.2)


'
More on importing and exporting datetimes
Fast parsing
parse_date_time() can be slow because it"s designed to be forgiving and flexible.

library(fasttime)
fastPOSIXct('2003-02-27') -> in

'2003-02-26 16:00:00 PST' -> out

fast_strptime()
x <- '2001-02-27'

parse_date_time(x, order='ymd') -> in

'2001-02-27 UTC' -> out

fast_strptime(x, format='%Y-%m-%d') -> in

'2001-02-27 UTC' -> out

fast_strptime(x, format='%y-%m-%d') -> in

NA -> out

* See Details of format in strptime()

Exporting datetimes
library(tidyverse)

akl_hourly %>%
  select(datetime) %>%
  write_csv('tmp.csv')

tmp.csv -> in

datetime
2016-01-01T00:00:00Z
2016-01-01T00:30:00Z
2016-01-01T01:00:00Z
2016-01-01T01:30:00Z
2016-01-01T02:00:00Z
2016-01-01T02:30:00Z -> out

Formatting datetimes
my_stamp <- stamp('Tuesday October 10 2017') -> in

Multiple formats matched: '%A %B %d %y%H'(1), '%A %B %y %d%H'(1),
'%A %B %d %Y'(1), '%A October %m %y%d'(1), '%A October %m %Y'(0),
'%A October %H %M%S'(1), 'Tuesday %B %d %y%H'(1), 'Tuesday %B %y %d%H'(1),
'Tuesday %B %d %Y'(1), 'Tuesday October %m %y%d'(1),
'Tuesday October %m %Y'(1), 'Tuesday October %H %M%S'(1)
Using: '%A %B %d %Y' -> out

my_stamp(ymd('2003-02-27')) -> in

'Thursday February 27 2003' -> out

my_stamp
function(x)
format(x, format='%A %B %d %Y') -> in

<environment: 0x1086ed780) -> out
'

library(microbenchmark)
library(fasttime)

# Examine structure of dates
str(dates)

# Use fastPOSIXct() to parse dates
fastPOSIXct(dates) %>% str()

# Compare speed of fastPOSIXct() to ymd_hms()
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  times = 20)


# Head of dates
head(dates)

# Parse dates with fast_strptime
fast_strptime(dates, 
    format = "%Y-%m-%dT%H:%M:%SZ") %>% str()

# Comparse speed to ymd_hms() and fasttime
microbenchmark(
  ymd_hms = ymd_hms(dates),
  fasttime = fastPOSIXct(dates),
  fast_strptime = fast_strptime(dates, 
    format = "%Y-%m-%dT%H:%M:%SZ"),
  times = 20)


# Create a stamp based on "Saturday, Jan 1, 2000"
date_stamp <- stamp('Saturday, Jan 1, 2000')

# Print date_stamp
date_stamp

# Call date_stamp on today()
date_stamp(today())

# Create and call a stamp based on "12/31/1999"
stamp('12/31/1999')(today())

# Use string finished for stamp()
stamp(finished)(today())
