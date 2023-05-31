' Data cleaning and summarizing with dplyr '

'
The United Nations Voting Dataset
Votes in dplyr
# Load dplyr package
library(dplyr)
votes -> in

# A tibble: 508,929 x 4
    rcid  session    vote   ccode
    <dbl>   <dbl>   <dbl>   <int>
1      46       2       1       2
2      46       2       1      20
3      46       2       9      31
4      46       2       1      40
5      46       2       1      41
6      46       2       1      42
7      46       2       9      51
8      46       2       9      52
9      46       2       9      53
10     46       2       9      54
# ... 508,919 more rows -> out

The pipe operator
%>%

dplyr verbs: filter
filter keeps observations based on a condition

votes %>%
  filter(vote <= 3) -> in

# A tibble: 353,547 x 4
    rcid  session    vote   ccode
    <dbl>   <dbl>   <dbl>   <int>
1      46       2       1       2
2      46       2       1      20
3      46       2       1      40
4      46       2       1      41
5      46       2       1      42
6      46       2       1      70
7      46       2       1      90
8      46       2       1      91
9      46       2       1      92
10     46       2       1      93
# ... 353,537 more rows -> out

dplyr verbs: mutate
mutate adds an additional variable

votes %>%
  mutate(year = session + 1945) -> in

# A tibble: 508,929 x 4
    rcid   session   vote   ccode   year
    <dbl>    <dbl>  <dbl>   <int>   <dbl>
1      46        2      1       2   1947
2      46        2      1      20   1947
3      46        2      1      40   1947
4      46        2      1      41   1947
5      46        2      1      42   1947 -> out

library(countrycode)

# Translate the country code 2
countrycode(2, "cown", "country.name") -> in

[1] "United States" -> out

# Translate multiple country codes
countrycode(c(2, 20, 40), "cown", "country.name") -> in

[1] "United States"     "Canada"        "Cuba" -> out
'

# Load the dplyr package
library(dplyr)

# Print the votes dataset
votes

# Filter for votes that are "yes", "abstain", or "no"
votes %>%
  filter(vote <= 3)


# Add another %>% step to add a year column
votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945)


# Load the countrycode package
library(countrycode)

# Convert country code 100
countrycode(100, "cown", "country.name")

# Add a country column within the mutate: votes_processed
votes_processed <- votes %>%
  filter(vote <= 3) %>%
  mutate(year = session + 1945, country = countrycode(ccode, "cown", "country.name"))


'
Grouping and summarizing
Processed votes
votes_processed -> in

# A tibble: 353,547 x 4
    rcid  session    vote   ccode   year              country
    <dbl>   <dbl>   <dbl>   <int>  <dbl>                <chr>
1      46       2       1       2   1947        United States
2      46       2       1      20   1947               Canada
3      46       2       9      31   1947                 Cuba
4      46       2       1      40   1947                Haiti
5      46       2       1      41   1947   Dominican Republic
6      46       2       1      42   1947               Mexico
7      46       2       9      51   1947            Guatemala
8      46       2       9      52   1947             Honduras
9      46       2       9      53   1947          El Salvador
10     46       2       9      54   1947            Nicaragua
# ... 353,537 more rows     -> out

dplyr verb: summarize
summarize() turns many rows into one - while calculating overall metrics, such as an average or total.

votes_processed %>%
  summarize(total = n(), percent_yes = mean(vote == 1)) -> in

# A tibble: 1 x 1
    total   percent_yes
    <int>         <dbl>
1  353547     0.7999248     -> out

- mean(vote == 1) is a way of calculating 'percent of vote equal to 1'

dplyr verb: group_by
- group_by() before summarize() turns groups into one row each

votes_processed %>%
  group_by(year) %>%
  summarize(total = n(), percent_yes = mean(vote == 1)) -> in

# A tibble: 34 x 3
    year    total   percent_yes
    <dbl>   <int>         <dbl>
1   1947     2039     0.5693968
2   1949     3469     0.4375901
3   1951     1434     0.5850767
4   1953     1537     0.6317502
5   1955     2169     0.6947902
6   1957     2708     0.6085672
7   1959     4326     0.5880721
8   1961     7482     0.5729751
9   1963     3308     0.7294438
10  1965     4382     0.7078959
# ... with 24 more rows -> out
'

# Print votes_processed
votes_processed

# Find total and fraction of "yes" votes
votes_processed %>%
  summarize(total=n(), percent_yes=mean(vote==1))


# Change this code to summarize by year
votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))


# Summarize by country: by_country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))


'
Sorting and filtering summarized data
by_country dataset
by_country -> in

# A tibble: 200 x 3
                country     total   percent_yes
                <chr>       <int>         <dbl>
1           Afghanistan      2373     0.8592499
2               Albania      1695     0.7174041
3               Algeria      2213     0.8992318
4               Andorra       719     0.6383866
5                Angola      1431     0.9238295
6   Antigua and Barbuda      1302     0.9124424
7             Argentina      2553     0.7677242
8               Armenia       758     0.7467016
9             Australia      2575     0.5565049
10              Austria      2389     0.6224362
# ... with 190 more rows -> out

dplyr verb: arrange()
It sorts a table based on a variable

by_country %>%
  arrange(percent_yes) -> in

# A tibble: 200 x 3
                        country     total     percent_yes
                        <chr>       <int>           <dbl>
1                      Zanzibar         2       0.0000000
2                 United States      2568       0.2694704
3                         Palau       369       0.3387534
4                        Israel      2380       0.3407563
5   Federal Republic of Germany      1075       0.3972093
6                United Kingdom      2558       0.4167318
7                        France      2527       0.4265928
8  Micronesia, Federated States of    724       0.4419890
9              Marshall Islands       757       0.4914135
10                      Belgium      2568       0.4922118
# ... with 190 more rows -> out
'

# You have the votes summarized by country
by_country <- votes_processed %>%
  group_by(country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print the by_country dataset
by_country

# Sort in ascending order of percent_yes
by_country %>%
  arrange(percent_yes)

# Now sort in descending order
by_country %>%
  arrange(desc(percent_yes))


# Filter out countries with fewer than 100 votes
by_country %>%
  arrange(percent_yes) %>%
  filter(total >= 100)


' Data visualization with ggplot2 '

'
Data visualization with ggplot2
by_year - >in

# A tibble: 34 x 3
    year    total   percent_yes
    <dbl>   <int>         <dbl>
1   1947     2039     0.5693968
2   1949     3469     0.4375901
3   1951     1434     0.5850767
4   1953     1537     0.6317502
5   1955     2169     0.6947902
6   1957     2708     0.6085672
7   1959     4326     0.5880721
8   1961     7482     0.5729751
9   1963     3308     0.7294438
10  1965     4382     0.7078959
# ... with 24 more rows -> out

Visualizing by-year data
library(ggplot2)

ggplot(by_country, aes(x=year, y=percent_yes)) + geom_line()
'

# Define by_year
by_year <- votes_processed %>%
  group_by(year) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Load the ggplot2 package
library(ggplot2)

# Create line plot
ggplot(by_year, aes(x=year, y=percent_yes)) + geom_line()


# Change to scatter plot and add smoothing curve
ggplot(by_year, aes(year, percent_yes)) +
  geom_point() + geom_smooth()


'
Visualizing by country
Summarizing by country and year
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))
by_year_country -> in

# A tibble: 4,744 x 4
# Groups:  year [34]
    year        country total percent_yes
    <dbl>         <chr> <int>       <dbl>
1   1947    Afghanistan    34   0.3823529
2   1947      Argentina    38   0.5789474
3   1947      Australia    38   0.5526316
4   1947        Belarus    38   0.5000000
5   1947        Belgium    38   0.6052632
# ... with 4,739 more rows -> out

Filtering for one country
by_year_country %>%
  filter(country == 'United States') -> in

# A tibble: 34 x 4
    year          country   total percent_yes
    <dbl>           <chr>   <int>       <dbl>
1   1947    United States      38   0.7105263
2   1949    United States      64   0.2812500
3   1951    United States      25   0.4000000
4   1953    United States      26   0.5000000
5   1955    United States      37   0.6216216
6   1957    United States      34   0.6470588
7   1959    United States      54   0.4259259
8   1961    United States      75   0.5066667
9   1963    United States      32   0.5000000
10  1965    United States      41   0.3658537
# ... with 24 more rows -> out

The %in% operator
c('A', 'B', 'C', 'D', 'E') %in% c('B', 'E') -> in

FALSE TRUE FALSE FALSE TRUE -> out

Filtering for multiple countries
us_france <- by_year_country %>%
  filter(country %in% c('United States', 'France')) 
us_france -> in

# A tibble: 68 x 4
    year       country  total percent_yes
    <dbl>        <chr>  <int>       <dbl>
1   1947        France     38   0.7368421
2   1947 United States     38   0.7105263
3   1949        France     64   0.3125000
4   1949 United States     64   0.2812500
5   1951        France     25   0.3600000
6   1951 United States     25   0.4000000
7   1953        France     18   0.3333333
8   1953 United States     26   0.5000000
9   1955        France     27   0.7407407
10  1955 United States     37   0.6216216
# ... with 58 more rows -> out

ggplot(us_france, aes(x=year, y=percent_yes, color=country)) + geom_line()
'

# Group by year and country: by_year_country
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))


# Start with by_year_country dataset
by_year_country <- votes_processed %>%
  group_by(year, country) %>%
  summarize(total = n(),
            percent_yes = mean(vote == 1))

# Print by_year_country
by_year_country

# Create a filtered version: UK_by_year
UK_by_year <- by_year_country %>%
  filter(country == 'United Kingdom')

# Line plot of percent_yes over time for UK only
ggplot(UK_by_year, aes(year, percent_yes)) +
  geom_line()


# Vector of four countries to examine
countries <- c("United States", "United Kingdom", "France", "India")

# Filter by_year_country: filtered_4_countries
filtered_4_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes in four countries
ggplot(filtered_4_countries, aes(year, percent_yes, color=country)) +
  geom_line()


'
Faceting by country
Graphing many countries
ggplot(many_countries, aes(x=year, y=percent_yes)) + geom_line() + facet_wrap(~ country, scales='free_y')
'

# Vector of six countries to examine
countries <- c("United States", "United Kingdom", "France", "Japan", "Brazil", "India")

# Filtered by_year_country: filtered_6_countries
filtered_6_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_6_countries, aes(year, percent_yes)) +
  geom_line() + 
  facet_wrap(~ country)


# Vector of six countries to examine
countries <- c("United States", "United Kingdom",
               "France", "Japan", "Brazil", "India")

# Filtered by_year_country: filtered_6_countries
filtered_6_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_6_countries, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~ country, scale='free_y')


# Add three more countries to this list
countries <- c("United States", "United Kingdom",
               "France", "Japan", "Brazil", "India", "Nigeria", "China", "Portugal")

# Filtered by_year_country: filtered_countries
filtered_countries <- by_year_country %>%
  filter(country %in% countries)

# Line plot of % yes over time faceted by country
ggplot(filtered_countries, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~ country, scales = "free_y")


' Tidy modeling with broom '

'
Tidy modeling with broom
Linear regression
Fitting model to Afghanistan
afghanistan <- by_year_country %>%
  filter(country == 'Afghanistan') -> in
afghanistan -> in

# A tibble: 34 x 4
    year          country   total percent_yes
    <dbl>           <chr>   <int>       <dbl>
1   1947    Afghanistan        34   0.3823529
2   1949    Afghanistan        51   0.6078431
3   1951    Afghanistan        25   0.7600000
4   1953    Afghanistan        26   0.7692308
5   1955    Afghanistan        37   0.7297297
6   1957    Afghanistan        34   0.5294118
7   1959    Afghanistan        54   0.6111111
8   1961    Afghanistan        76   0.6052632
9   1963    Afghanistan        32   0.7812500
10  1965    Afghanistan        40   0.8500000
# ... with 24 more rows -> out

model <- lm(percent_yes ~ year, data=afghanistan)

summary(model) -> in

Call:
lm(formula = percent_yes ~ year, data = afghanistan)
Residuals: 
        Min        1Q      Median         3Q         Max
-0.254667   -0.038650   -0.001945   0.057110    0.140596
Coefficients:
                Estimate   Std. Error  t value  Pr(>|t|)
(Intercept)   -1.106e+01    1.471e+00   -7.523  1.44e-08 ***
year           6.009e-03    7.426e-04    8.092  3.06e-09 ***        # 6.009e-03 is the slope
<hr />
Signif. codes: 0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 '' 1
Residual standard error: 0.08497 on 32 degrees of freedom
Multiple R-squared: 0.6717,\tAdjusted R-squared: 0.6615
F-statistic: 65.48 on 1 and 32 DF, p-value: 3.065e-09               # 3.065e-09 is the p-value
positive slope
3e-09 = .000000003 -> out

Visualization can surprise you, but it doesn"t scale well.
Modeling scales well, but it can"t surprise you - Hadley Wickham
'

# Percentage of yes votes from the US by year: US_by_year
US_by_year <- by_year_country %>%
  filter(country == "United States")

# Print the US_by_year data
US_by_year

# Perform a linear regression of percent_yes by year: US_fit
US_fit <- lm(percent_yes ~ year, data=US_by_year)

# Perform summary() on the US_fit object
summary(US_fit)


'
Tidying models with broom
models are difficult to combine
model1 <- lm(percent_yes ~ year, data=afghanistan)
model2 <- lm(percent_yes ~ year, data=united_states)
model3 <- lm(percent_yes ~ year, data=canada)

broom turns a model into a dataframe
library(broom)
tidy(model) -> in

        term        estimate       std.error   statistic         p.value
1 (Intercept)  -11.063084650    1.4705189228   -7.523252    1.444892e-08
2        year    0.006009299    0.0007426499    8.091698    3.064797e-09 -> out

Tidy models can be combined
model1 <- lm(percent_yes ~ year, data=afghanistan)
model2 <- lm(percent_yes ~ year, data=united_states)
tidy(model1) -> in

        term        estimate       std.error   statistic         p.value
1 (Intercept)  -11.063084650    1.4705189228   -7.523252    1.444892e-08
2        year    0.006009299    0.0007426499    8.091698    3.064797e-09 -> out

tidy(model2) -> in

        term        estimate       std.error   statistic         p.value
1 (Intercept)   12.664145512    1.8379742715    6.890274    8.477089e-08
2       year    -0.006239305    0.0009282243   -6.721764    1.366904e-07 -> out

bind_rows(tidy(model1), tidy(model2)) -> in

        term        estimate       std.error   statistic         p.value
1 (Intercept)  -11.063084650    1.4705189228   -7.523252     1.444892e-08
2        year    0.006009299    0.0007426499    8.091698     3.064797e-09
3 (Intercept)   12.664145512    1.8379742715    6.890274     8.477089e-08
4        year   -0.006239305    0.0009282243   -6.721764     1.366904e-07 -> out
'

# Load the broom package
library(broom)

# Call the tidy() function on the US_fit object
tidy(US_fit)


# Linear regression of percent_yes by year for US
US_by_year <- by_year_country %>%
  filter(country == "United States")
US_fit <- lm(percent_yes ~ year, US_by_year)

# Fit model for the United Kingdom
UK_by_year <- by_year_country %>%
  filter(country == "United Kingdom")
UK_fit <- lm(percent_yes ~ year, UK_by_year)

# Create US_tidied and UK_tidied
US_tidied <- tidy(US_fit)
UK_tidied <- tidy(UK_fit)

# Combine the two tidied models
bind_rows(US_tidied, UK_tidied)


'
Nesting for multiple models
Start with one row per country
by_year_country -> in

# A tibble: 4,744 x 4
# Groups:  year [34]
    year                            country  total   percent_yes
    <dbl>                             <chr>  <int>         <dbl>
1   1947                        Afghanistan     34     0.3823529
2   1947                          Argentina     38     0.5789474
3   1947                          Australia     38     0.5526316
4   1947                            Belarus     38     0.5000000
5   1947                            Belgium     38     0.6052632
6   1947    Bolivia, Plurinational State of     37     0.5945946
7   1947                             Brazil     38     0.6578947
8   1947                             Canada     38     0.6052632
9   1947                              Chile     38     0.6578947
10  1947                           Colombia     35     0.5428571
# ... with 4,734 more rows -> out

nest() turns it into one row per country
library(tidyr)
by_year_country %>%
  nest(-country) -> in

# A tibble: 200 x 2
                            country                  data
                            <chr>                  <list>
1                       Afghanistan     <tibble [34 x 3]>
2                         Argentina     <tibble [34 x 3]>
3                         Australia     <tibble [34 x 3]>
4                           Belarus     <tibble [34 x 3]>
5                           Belgium     <tibble [34 x 3]>
6   Bolivia, Plurinational State of     <tibble [34 x 3]> 
7                            Brazil     <tibble [34 x 3]>
8                            Canada     <tibble [34 x 3]>
9                             Chile     <tibble [34 x 3]>
10                         Colombia     <tibble [34 x 3]>
# ... with 190 more rows -> out

* -country means 'nest all except country'

* 'nested' year, total, percent_yes data for just Afghanistan

# A tibble: 34 x 4
    year        country     total percent_yes
    <dbl>         <chr>     <int>       <dbl>
1   1947    Afghanistan        34   0.3823529
2   1949    Afghanistan        51   0.6078431
3   1951    Afghanistan        25   0.7600000
4   1953    Afghanistan        26   0.7692308
5   1955    Afghanistan        37   0.7297297
6   1957    Afghanistan        34   0.5294118
7   1959    Afghanistan        54   0.6111111
8   1961    Afghanistan        76   0.6052632
9   1963    Afghanistan        32   0.7812500
10  1965    Afghanistan        40   0.8500000
# ... with 24 more rows 

unnest() does the opposite
by_year_country %>%
  nest(-country) %>%
  unnest(data) -> in

# A tibble: 4,744 x 4
# Groups:  year [34]
    year    total   percent_yes             country 
    <dbl>   <int>         <dbl>              <chr>
1   1947       34     0.3823529        Afghanistan
2   1947       38     0.5789474          Argentina
3   1947       38     0.5889474     United Kingdom
4   1947       38     0.5526316          Australia
5   1947       38     0.5000000            Belarus
6   1947       38     0.5000000              Egypt
7   1947       38     0.5000000       South Africa
8   1947       38     0.5000000         Yugoslavia
9   1947       38     0.6052632            Belgium
10  1947       38     0.6052632             Canada 
# ... with 4,734 more rows -> out
'

# Load the tidyr package
library(tidyr)

# Nest all columns besides country
by_year_country %>%
  nest(-country)


# All countries are nested besides country
nested <- by_year_country %>%
  nest(-country)

# Print the nested data for Brazil
nested$data[[7]]


# All countries are nested besides country
nested <- by_year_country %>%
  nest(-country)

# Unnest the data column to return it to its original form
by_year_country %>%
  nest(-country) %>%
  unnest(data)


'
Fitting multiple models
map() applies an operation to each item in a list
v <- list(1, 2, 3)
map(x, ~. * 10) -> in

[[1]]
[1] 10

[[2]]
[1] 20

[[3]]
[1] 30 -> out

map() fits a model to each dataset
library(purrr)

by_year_country %>%
  nest(-country) %>%
  mutate(models = map(data, ~lm(percent_yes ~ year, .))) %>%
  mutate(tidied = map(models, tidy)) -> in

# A tibble: 200 x 3
                            country                  data      models                 tidied
                            <chr>                  <list>      <list>                 <list>
1                       Afghanistan     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
2                         Argentina     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
3                         Australia     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
4                           Belarus     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
5                           Belgium     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
6   Bolivia, Plurinational State of     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]> 
7                            Brazil     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
8                            Canada     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
9                             Chile     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
10                         Colombia     <tibble [34 x 3]>    <s3: lm>   <data.frame [2 x 5]>
# ... with 190 more rows -> out

unnest() combines the tidied models
by_year_country %>%
  nest(-country) %>%
  mutate(models = map(data, ~lm(percent_yes ~ year, .))) %>%
  mutate(tidied = map(models, tidy)) %>%
  unnest(tidied)  -> in

# A tibble: 399 x 6
        country            term         estimate       std.error    statistic         p.value
            <chr>         <chr>            <dbl>           <dbl>        <dbl>           <dbl>
1     Afghanistan   (Intercept)    -11.063084650    1.4705189228    -7.523252    1.444892e-08
2     Afghanistan          year      0.006009299    0.0007426499     8.091698    3.064797e-09
3       Argentina   (Intercept)     -9.464512565    2.1008982371    -4.504984    8.322481e-05
4       Argentina          year      0.005148829    0.0010610076     4.852773    3.047078e-05
5       Australia   (Intercept)     -4.545492536    2.1479916283    -2.116159    4.220387e-02  
6       Australia          year      0.002567161    0.0010847910     2.366503    2.417617e-02
7         Belarus   (Intercept)     -7.000692717    1.5024232546    -4.659601    5.329950e-05
8         Belarus          year      0.003907557    0.0007587624     5.149908    1.284924e-05
9         Belgium   (Intercept)     -5.845534016    1.5153390521    -3.857575    5.216573e-04
10        Belgium          year      0.003203234    0.0007652852     4.185673    2.072981e-04
# ... with 389 more rows -> out
'

# Load tidyr and purrr
library(tidyr)
library(purrr)

# Perform a linear regression on each item in the data column
by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)))


# Load the broom package
library(broom)

# Add another mutate that applies tidy() to each model
by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .))) %>%
  mutate(tidied = map(model, tidy))


# Add one more step that unnests the tidied column
country_coefficients <- by_year_country %>%
  nest(-country) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)), tidied = map(model, tidy)) %>%
  unnest(tidied)

# Print the resulting country_coefficients variable
country_coefficients


'
Working with many tidy models
- For a trend to be significant, its often required that the p-value be less tha 0.05
- Multiple hypothesis correction is done  because some p-values will be less than 0.05 by chance.

Filter for the year term (slope) and adjusted p-value
country_coefficients %>%
  filter(term == 'year') %>%
  filter(p.adjust(p.value) < 0.05 ) -> in

# A tibble: 61 x 6
                            country          term         estimate       std.error    statistic         p.value
                            <chr>           <chr>            <dbl>           <dbl>        <dbl>           <dbl>
1                       Afghanistan          year      0.006009299    0.0007426499     8.091698    3.064797e-09
2                         Argentina          year      0.005148829    0.0010610076     4.852773    3.047078e-05
3                           Belarus          year      0.003907557    0.0007587624     5.149908    1.284924e-05
4                           Belgium          year      0.003203234    0.0007652852     4.185673    2.072981e-04
5   Bolivia, Plurinational State of          year      0.005802864    0.0009657515     6.008651    1.058595e-06
6                            Brazil          year      0.006107151    0.0008167736     7.477164    1.641169e-08
7                             Chile          year      0.006775560    0.0008220463     8.242310    2.045608e-09
8                          Colombia          year      0.006157755    0.0009645084     6.384346    3.584226e-07
9                        Costa Rica          year      0.006539273    0.0008119113     8.054171    3.391094e-09
10                             Cuba          year      0.004610867    0.0007205029     6.399512    3.431579e-07
# ... with 51 more rows -> out
'

# Print the country_coefficients dataset
country_coefficients

# Filter for only the slope terms
country_coefficients %>%
  filter(term == 'year')


# Filter for only the slope terms
slope_terms <- country_coefficients %>%
  filter(term == "year")

# Add p.adjusted column, then filter
country_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < 0.05)


# Filter by adjusted p-values
filtered_countries <- country_coefficients %>%
  filter(term == "year") %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < .05)

# Sort for the countries increasing most quickly
filtered_countries %>%
  arrange(estimate)

# Sort for the countries decreasing most quickly
filtered_countries %>%
  arrange(desc(estimate))


' Joining and tidying '

'
Joining datasets
Processed votes
votes_processed -> in

# A tibble: 353,547 x 4
    rcid  session    vote   ccode   year              country
    <dbl>   <dbl>   <dbl>   <int>  <dbl>                <chr>
1      46       2       1       2   1947        United States
2      46       2       1      20   1947               Canada
3      46       2       9      31   1947                 Cuba
4      46       2       1      40   1947                Haiti
5      46       2       1      41   1947   Dominican Republic
6      46       2       1      42   1947               Mexico
7      46       2       9      51   1947            Guatemala
8      46       2       9      52   1947             Honduras
9      46       2       9      53   1947          El Salvador
10     46       2       9      54   1947            Nicaragua
# ... 353,537 more rows     -> out

* Each row is one roll call / country pair.

Descriptions dataset
me: Palestinian conflict
nu: Nuclear weapons and nuclear material
di: Arms control and disarmament
hr: Human rights
co: Colonialism
ec: Economic development

descriptions -> in

# A tibble: 2,589 x 10
    rcid  session             date         unres     me     nu     di     hr     co     ec
    <dbl>   <dbl>           <dttm>         <chr>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>                
1      46       2       1947-09-04       R/2/299      0      0      0      0      0      0
2      47       2       1947-10-05       R/2/355      0      0      0      1      0      0
3      48       2       1947-10-06       R/2/461      0      0      0      0      0      0
4      49       2       1947-10-06       R/2/463      0      0      0      0      0      0
5      50       2       1947-10-06       R/2/465      0      0      0      0      0      0
6      51       2       1947-10-02       R/2/561      0      0      0      0      1      0
7      52       2       1947-11-06       R/2/650      0      0      0      0      1      0
8      53       2       1947-11-06       R/2/651      0      0      0      0      1      0
9      54       2       1947-11-06       R/2/651      0      0      0      0      1      0
10     55       2       1947-11-06       R/2/667      0      0      0      0      1      0
# ... 2,579 more rows     -> out

inner_join()
votes_processed %>%
  inner_join(descriptions, by=c('rcid', 'session')) -> in

    rcid  session    vote   ccode   year              country        date    unres     me
    <dbl>   <dbl>   <dbl>   <int>  <dbl>                <chr>      <dttm>    <chr>  <dbl>
1      46       2       1       2   1947        United States  1947-09-04  R/2/299      0
2      46       2       1      20   1947               Canada  1947-09-04  R/2/299      0
3      46       2       9      31   1947                 Cuba  1947-09-04  R/2/299      0
4      46       2       1      40   1947                Haiti  1947-09-04  R/2/299      0
5      46       2       1      41   1947   Dominican Republic  1947-09-04  R/2/299      0
6      46       2       1      42   1947               Mexico  1947-09-04  R/2/299      0
7      46       2       9      51   1947            Guatemala  1947-09-04  R/2/299      0
8      46       2       9      52   1947             Honduras  1947-09-04  R/2/299      0
9      46       2       9      53   1947          El Salvador  1947-09-04  R/2/299      0
10     46       2       9      54   1947            Nicaragua  1947-09-04  R/2/299      0
# ... 353,537 more rows, and 5 more variables:  nu <dbl>, di <dbl>, hr <dbl>, co <dbl>, ec <dbl>     -> out
'

# Load dplyr package
library(dplyr)

# Print the votes_processed dataset
votes_processed

# Print the descriptions dataset
descriptions

# Join them together based on the "rcid" and "session" columns
votes_joined <- votes_processed %>%
  inner_join(descriptions, by = c("rcid", "session"))


# Filter for votes related to colonialism
votes_joined %>%
  filter(co == 1)


# Load the ggplot2 package
library(ggplot2)

# Filter, then summarize by year: US_co_by_year
US_co_by_year <- votes_joined %>%
  filter(country == 'United States', co == 1) %>%
  group_by(year) %>%
  summarize(percent_yes = mean(vote == 1))

# Graph the % of "yes" votes over time
ggplot(US_co_by_year, aes(year, percent_yes)) +
  geom_line()


'
Tidy data
Topic is spread across six columns
* Each topic has one column, so combine into a single variable: topic

votes_joined %>%
  select(rcid, session, vote, country, me:ec) -> in

# A tibble: 353,547 x 10
    rcid  session    vote                 country     me     nu     di     hr     co     ec
    <dbl>   <dbl>   <dbl>                   <chr>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>  <dbl>
1      46       2       1           United States      0      0      0      0      0      0
2      46       2       1                  Canada      0      0      0      0      0      0
3      46       2       1                    Cuba      0      0      0      0      0      0
4      46       2       1                   Haiti      0      0      0      0      0      0
5      46       2       1      Dominican Republic      0      0      0      0      0      0
6      46       2       1                  Mexico      0      0      0      0      0      0
7      46       2       1               Guatemala      0      0      0      0      0      0
8      46       2       1                Honduras      0      0      0      0      0      0
9      46       2       1             El Salvador      0      0      0      0      0      0
10     46       2       1               Nicaragua      0      0      0      0      0      0
# ... 353,537 more rows -> out

Use gather() to bring columns into two variables
gather() is a reshaping operation that takes any number of columns and collects them into two: key with the originak column names and value, with the contents of those columns.

library(tidyr)

votes_joines %>%
  gather(topic, has_topic, me:ec) %>%
  filter(has_topic == 1) -> in

# A tibble: 350,032 x 10
    rcid  session    vote   ccode   year              country        date     unres   topic     has_topic
    <dbl>   <dbl>   <dbl>   <int>  <dbl>                <chr>      <dttm>     <chr>   <chr>         <dbl>
1      77       2       1       2   1947        United States  1947-11-06  R/2/1424      me             1
2      77       2       1      20   1947               Canada  1947-11-06  R/2/1424      me             1
3      77       2       3      40   1947                 Cuba  1947-11-06  R/2/1424      me             1
4      77       2       1      41   1947                Haiti  1947-11-06  R/2/1424      me             1
5      77       2       1      42   1947   Dominican Republic  1947-11-06  R/2/1424      me             1
6      77       2       2      70   1947               Mexico  1947-11-06  R/2/1424      me             1
7      77       2       1      90   1947            Guatemala  1947-11-06  R/2/1424      me             1
8      77       2       2      91   1947             Honduras  1947-11-06  R/2/1424      me             1
9      77       2       2      92   1947          El Salvador  1947-11-06  R/2/1424      me             1
10     77       2       1      93   1947            Nicaragua  1947-11-06  R/2/1424      me             1
# ... with 350,022 more rows     -> out

* 'topic' is now a variable
'

# Load the tidyr package
library(tidyr)

# Gather the six me/nu/di/hr/co/ec columns
votes_joined %>%
  gather(topic, has_topic, me:ec)

# Perform gather again, then filter
votes_gathered <- votes_joined %>%
  gather(topic, has_topic, me:ec) %>%
  filter(has_topic == 1)


# Replace the two-letter codes in topic: votes_tidied
votes_tidied <- votes_gathered %>%
  mutate(topic = recode(topic,
                        me = "Palestinian conflict",
                        nu = "Nuclear weapons and nuclear material",
                        di = "Arms control and disarmament",
                        hr = "Human rights",
                        co = "Colonialism",
                        ec = "Economic development"))


# Print votes_tidied
votes_tidied

# Summarize the percentage "yes" per country-year-topic
by_country_year_topic <- votes_tidied %>%
  group_by(country, year, topic) %>%
  summarize(total=n(), percent_yes=mean(vote == 1)) %>%
  ungroup()

# Print by_country_year_topic
by_country_year_topic


# Load the ggplot2 package
library(ggplot2)

# Filter by_country_year_topic for just the US
US_by_country_year_topic <- by_country_year_topic %>%
  filter(country == 'United States')

# Plot % yes over time for the US, faceting by topic
ggplot(US_by_country_year_topic, aes(year, percent_yes)) + 
  geom_line() + 
    facet_wrap(~topic)


'
Tidy modeling by topic and country
library(purrr)
library(broom)

country_topic_coefficients <- by_year_country_topic %>%
  nest(-country, -topic) %>%
  mutate(model = map(data, ~lm(percent_yes ~ year, data = .)), tidied = map(model, tidy)) %>%
  unnest(tidied)  -> in

# A tibble: 2,383 x 7
        country                            topic          term         estimate       std.error
            <chr>                          <chr>         <chr>            <dbl>           <dbl>
1     Afghanistan                    Colonialism   (Intercept)     -9.196506325    1.9573746777 
2     Afghanistan                    Colonialism          year      0.005106200    0.0009885245
3     Afghanistan           Economic development   (Intercept)    -11.476390441    3.6191205187
4     Afghanistan           Economic development          year      0.006239157    0.0018265400
5     Afghanistan                   Human rights   (Intercept)     -7.265379964    4.3740212201  
6     Afghanistan                   Human rights          year      0.004075877    0.0022089932
7     Afghanistan           Palestinian conflict   (Intercept)    -13.313363338    3.5707983095
8     Afghanistan           Palestinian conflict          year      0.007167675    0.0018002649
9     Afghanistan   Arms control and disarmament   (Intercept)    -13.759624843    4.1328667932
10    Afghanistan   Arms control and disarmament          year      0.007369733    0.0020837753
# ... with 2,373 more rows, and 2 more variables: statistic <dbl>, p.value <dbl> -> out
'

# Load purrr, tidyr, and broom
library(purrr)
library(tidyr)
library(broom)

# Print by_country_year_topic
by_country_year_topic

# Fit model on the by_country_year_topic dataset
country_topic_coefficients <- by_country_year_topic %>%
  nest(-country, -topic) %>%
  mutate(model = map(data, ~ lm(percent_yes ~ year, data = .)), tidied = map(model, tidy)) %>%
  unnest(tidied)

# Print country_topic_coefficients
country_topic_coefficients


# Create country_topic_filtered
country_topic_filtered <- country_topic_coefficients %>%
  filter(term == 'year') %>%
  mutate(p.adjusted = p.adjust(p.value)) %>%
  filter(p.adjusted < 0.05)


# Create vanuatu_by_country_year_topic
vanuatu_by_country_year_topic <- by_country_year_topic %>%
  filter(country == 'Vanuatu')

# Plot of percentage "yes" over time, faceted by topic
ggplot(vanuatu_by_country_year_topic, aes(year, percent_yes)) +
  geom_line() +
  facet_wrap(~topic)