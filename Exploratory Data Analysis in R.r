' Exploring Categorical Data '

'
Working with factors
levels(comics$align) -> in

'Bad', 'Good', 'Neutral', 'Reformed Criminals' -> out

levels(comics$id) -> in

'No Dual', 'Public', 'Secret', 'Unknown' # Note: NAs ignored by levels() function -> out

table(comics$align, comics$id) -> in

            Bad     Good    Neutral     Criminals
No Dual     474      647        390             0
Public     2172     2930        965             1
Secret     4493     2573        959             1
Unknown       7        0          2             0 ->out

ggplot(data, aes(x=var1, fill=var2)) + layer_name()

ggplot(comics, aes(x=id, fill=align)) + geom_bar()
'

# Print the comics data
comics

# Check levels of align
levels(comics$align)

# Check the levels of gender
levels(comics$gender)

# Create a 2-way contingency table
table(comics$align, comics$gender)


# Load dplyr
library(dplyr)

# Print tab
tab

# Remove align level
comics_filtered <- comics %>%
  filter(align != "Reformed Criminals") %>%
  droplevels()

# See the result
comics_filtered


# Load ggplot2
library(ggplot2)

# Create side-by-side bar chart of gender by alignment
ggplot(comics, aes(x = align, fill = gender)) + 
  geom_bar(position = "dodge")

# Create side-by-side bar chart of alignment by gender
ggplot(comics, aes(x = gender, fill = align)) + 
  geom_bar(position = "dodge") +
  theme(axis.text.x = element_text(angle = 90))


'
Counts vs. Proportions
options(scipen=999, digits=3)   # Simplify display format
tab_cnt <- table(comics$id, comics$align)
tab_cnt -> in

        Bad   Good  Neutral
No Dual  474   647      390
Public  2172  2930      965
Secret  4493  2475      959
Unknown    7     0        2 -> out

prop.table(tab_cnt) -> in

              Bad       Good   Neutral
No Dual   0.030553  0.041704  0.025139
Public    0.140003  0.188862  0.062202
Secret    0.289609  0.159533  0.061815
Unknown   0.000451  0.000000  0.000129 -> out

sum(prop.table(tab_cnt)) -> in

1 -> out

Conditional proportions
prop.table(tab_cnt, 1) -> in # By rows

            Bad    Good   Neutral
No Dual   0.314   0.428     0.258
Public    0.358   0.483     0.159
Secret    0.567   0.312     0.121
Unknown   0.778   0.000     0.222 -> out

prop.table(tab_cnt, 2) -> in # By columns

              Bad       Good   Neutral
No Dual   0.066331  0.106907  0.168394
Public    0.303946  0.484137  0.416667
Secret    0.628743  0.408956  0.414076
Unknown   0.000980  0.000000  0.000864 -> out

Conditional bar chart
ggplot(comics, aes(x=id, fill=align)) + geom_bar(position='fill') + ylab('proportion')
'

tab <- table(comics$align, comics$gender)
options(scipen = 999, digits = 3) # Print fewer digits
prop.table(tab)     # Joint proportions
prop.table(tab, 2)  # Conditional on columns


# Plot of gender by align
ggplot(comics, aes(x = align, fill = gender)) + geom_bar()

# Plot proportion of gender, conditional on align
ggplot(comics, aes(x = align, fill = gender)) + geom_bar(position = 'fill') + ylab("proportion")


'
Distribution of one variable
Marginal distributuion
table(comics$id) -> in

No Dual Public Secret Unknown
1511 6067 7927 9 -> out
tab_cnt <- table(comics$id, comics$align)
tab_cnt -> in

        Bad   Good  Neutral
No Dual  474   647      390
Public  2172  2930      965
Secret  4493  2475      959
Unknown    7     0        2 -> out

Simple bar chart
ggplot(comics, aes(x=id)) + geom_bar()

Faceting
This breaks the data into subsets based on the levels of a categorical variable and then constructs a plot for each.

Faceted bar charts
ggplot(comics, aes(x=id)) + geom_bar() + facet_wrap(~align)

Pie chart vs bar chart
The pie chart is a common way to display categorical data where the size of the slice corresponds to the proportion of cases that are in that level.
'

# Change the order of the levels in align
comics$align <- factor(comics$align, levels = c("Bad", "Neutral", "Good"))

# Create plot of align
ggplot(comics, aes(x = align)) + geom_bar()


# Plot of alignment broken down by gender
ggplot(comics, aes(x = align)) + geom_bar() + facet_wrap(~ gender)


# Put levels of flavor in descending order
lev <- c("apple", "key lime", "boston creme", "blueberry", "cherry", "pumpkin", "strawberry")
pies$flavor <- factor(pies$flavor, levels = lev)

# Create bar chart of flavor
ggplot(pies, aes(x = flavor)) + geom_bar(fill = "chartreuse") + theme(axis.text.x = element_text(angle = 90))


' Exploring Numerical Data '

'
Exploring Numerical Data
Cars dataset
str(cars) -> in

'data.frame': 428 obs. of 19 variables:
$ name :        chr   'Chevrolet Aveo 4dr' 'Chevrolet Aveo LS 4dr hatch' 'Chevrolet Cavalier 2dr' ...
$ sport_car :   logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ suv :         logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ wagon :       logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ minivan :     logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ pickup :      logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ all_wheel :   logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ rear_wheel :  logi  FALSE FALSE FALSE FALSE FALSE FALSE ...
$ msrp :        int   11690 12585 14610 14810 16385 13670 15040 13270 13730 15460 ...
$ dealer_cost : int   10965 11802 13697 13884 15357 12849 14086 12482 12906 14496 ...
$ eng_size :    num   1.6 1.6 2.2 2.2 2.2 2 2 2 2 2 ... 
$ ncyl :        int   4 4 4 4 4 4 4 4 4 4 ...
$ horsepwr :    int   103 103 140 140 140 132 132 130 110 130 ...
$ city_mpg :    int   28 28 26 26 26 29 29 26 27 26 ...
$ hwy_mpg :     int   34 34 37 37 37 36 36 33 36 33 ...
$ weight :      int   2370 2348 2617 2676 2617 2581 2626 2612 2606 2606 ...
$ wheel_base :  int   98 98 104 104 104 105 105 103 103 103 ...
$ length :      int   167 153 183 183 183 174 174 168 168 168 ...
$ width :       int   66 66 69 68 69 67 67 67 67 67 ...   -> out

Dotplot
ggplot(data, aes(x=weight)) + geom_dotplot(dotsize = 0.4)

Histogram
ggplot(data, aes(x=weight)) + geom_histogram()

Density
ggplot(data, aes(x=weight)) + geom_density()

Boxplot
ggplot(data, aes(x=1, y=weight)) + geom_boxplot() + coord_flip()

Faceted histogram
ggplot(cars, aes(x=hwy_mpg)) + geom_histogram() + facet_wrap(~pickup)
'

# Load package
library(ggplot2)

# Learn data structure
str(cars)

# Create faceted histogram
ggplot(cars, aes(x = city_mpg)) +
  geom_histogram() +
  facet_wrap(~ suv)


# Filter cars with 4, 6, 8 cylinders
common_cyl <- filter(cars, ncyl %in% c(4, 6, 8))

# Create box plots of city mpg by ncyl
ggplot(common_cyl, aes(x = as.factor(ncyl), y = city_mpg)) +
  geom_boxplot()

# Create overlaid density plots for same data
ggplot(common_cyl, aes(x = city_mpg, fill = as.factor(ncyl))) +
  geom_density(alpha = .3)


'
Distribution of one variable
Marginal vs Conditional
ggplot(cars, aes(x=hwy_mpg)) + geom_histogram()

ggplot(cars, aes(x=hwy_mpg)) + geom_histogram() + facet_wrap(~pickup)

Building a data pipeline
cars2 <- cars %>%
  filter(eng_size < 2.0)

ggplot(cars2, aes(x=hwy_mpg)) + geom_histogram()

cars %>%
  filter(eng_size < 2.0) %>%
  ggplot(cars2, aes(x=hwy_mpg)) + geom_histogram()

Wide bin width
cars %>%
  filter(eng_size < 2.0) %>%
  ggplot(cars2, aes(x=hwy_mpg)) + geom_histogram(binwidth=5)

Density plot
cars %>%
  filter(eng_size < 2.0) %>%
  ggplot(cars2, aes(x=hwy_mpg)) + geom_density()

Wide bandwidth
cars %>%
  filter(eng_size < 2.0) %>%
  ggplot(cars2, aes(x=hwy_mpg)) + geom_density(bw=5)
'

# Create hist of horsepwr
cars %>%
  ggplot(aes(x=horsepwr)) +
  geom_histogram() +
  ggtitle('hist of horsepwr')

# Create hist of horsepwr for affordable cars
cars %>% 
  filter(msrp < 25000) %>%
  ggplot(aes(x=horsepwr)) +
  geom_histogram() +
  xlim(c(90, 550)) +
  ggtitle('hist of horsepwr for affordable cars')


# Create hist of horsepwr with binwidth of 3
cars %>%
  ggplot(aes(x=horsepwr)) +
  geom_histogram(binwidth = 3) +
  ggtitle('hist of horsepwr with binwidth of 3')

# Create hist of horsepwr with binwidth of 30
cars %>%
  ggplot(aes(x=horsepwr)) +
  geom_histogram(binwidth = 30) +
  ggtitle('hist of horsepwr with binwidth of 30')

# Create hist of horsepwr with binwidth of 60
cars %>%
  ggplot(aes(x=horsepwr)) +
  geom_histogram(binwidth = 60) +
  ggtitle('hist of horsepwr with binwidth of 60')


'
Box plots
They really shine in situations where you need to compare several distributions at once and also as a means to detect outliers but one of their weaknesses though is that they have no capacity to indicate when a distribution has more than one hump or 'mode'.

Side-by-side box plots
ggplot(common_cyl, aes(x=as.factor(ncyl), y=city_mpg)) + geom_boxplot()
'

# Construct box plot of msrp
cars %>%
  ggplot(aes(x = 1, y = msrp)) +
  geom_boxplot()

# Exclude outliers from data
cars_no_out <- cars %>%
  filter(msrp < 100000)

# Construct box plot of msrp using the reduced dataset
cars_no_out %>%
  ggplot(aes(x = 1, y = msrp)) +
  geom_boxplot()


# Create plot of city_mpg
cars %>%
  ggplot(aes(x=1, y=city_mpg)) +
  geom_boxplot()

# Create plot of width
cars %>% 
  ggplot(aes(x=width)) +
  geom_density()


'
Visualization in higher dimensions
Plot for 3 variables
ggplot(cars, aes(x=msrp)) + geom_density() + facet_grid(pickup ~ rear_wheel, labeller = label_both)

table(cars$rear_wheel, cars$pickup) -> in

      FALSE   TRUE
FALSE   306     12
TRUE     98     12 -> out

Higher dimensional plots
- Shape
- Size
- Color
- Pattern
- Movement
- x-coordinate
- y-coordinate
'

# Facet hists using hwy mileage and ncyl
common_cyl %>%
  ggplot(aes(x = hwy_mpg)) +
  geom_histogram() +
  facet_grid(ncyl ~ suv) +
  ggtitle('Mileage by suv and ncyl')


' Numerical Summaries '

'
Measures of center
County demographics
life -> in

# A tibble: 3,142 x 4
    state            county expectancy   income
    <chr>             <chr>      <dbl>    <int>
1 Alabama    Autauga County     76.060    37773
2 Alabama    Baldwin County     77.630    40121
3 Alabama    Barbour County     74.675    31443
4 Alabama       Bibb County     74.155    29075
5 Alabama     Blount County     75.880    31663
6 Alabama    Bullock County     71.790    25929
7 Alabama     Butler County     73.730    33518
8 Alabama    Calhoun County     73.300    33418
9 Alabama   Chambers County     73.245    31282
10 Alabama  Cherokee County     74.650    32645
# ... with 3,132 more rows    -> out

Center: mean, median, mode
x <- head(round(life$expectancy), 11)
x -> in

76 78 75 74 76 72 74 73 73 75 74 -> out

sum(x) / 11 -> in

74.54545 -> out

mean(x) -> in

74.54545 -> out

sort(x) -> in

72 73 73 74 74 74 75 75 76 76 78 -> out

median(x) -> in

74 -> out

table(x)
x -> in

72 73 74 75 76 78
1    2    3   2   2   1 -> out

* When working with skewed distributions, the median is often a more appropriate measure of center.

Groupwise means
life <- life %>%
  mutate(west_coast = state %in% c('California', 'Oregon', 'Washington'))

life %>%
  groupby(west_coast) %>%
  summarize(mean(expectancy), median(expectancy))   -> in

# A tibble: 2 x 3
  west_coast  mean(expectancy)   median(expectancy)
      <lgl>              <dbl>                <dbl>
1 FALSE               77.12750                77.31
2 TRUE                78.90545                78.65   -> out

Without group_by()
life %>%
  slice(240:247) %>%
  summarize(mean(expectancy))   -> in

# A tibble: 1 x 1
    mean(expectancy)
              <dbl>
1           79.2775 -> out

With group_by()
life %>%
  slice(240:247) %>%
  group_by(west_coast) %>%
  summarize(mean(expectancy))   -> in

# A tibble: 2 x 2
  west_coast  mean(expectancy)
      <lgl>              <dbl>
1 FALSE               79.26125
2 TRUE                79.29375  -> out
'

# Create dataset of 2007 data
gap2007 <- filter(gapminder, year == 2007)

# Compute groupwise mean and median lifeExp
gap2007 %>%
  group_by(continent) %>%
  summarize(mean(lifeExp), median(lifeExp))

# Generate box plots of lifeExp for each continent
gap2007 %>%
  ggplot(aes(x = continent, y = lifeExp)) +
  geom_boxplot()


'
Measures of variability
x -> in

76 78 75 74 76 72 74 73 73 75 74 -> out

x - mean(x) -> in

1.4545 3.4545 0.4545 -0.5455 1.45454 -2.5455 -0.5455 -1.5455 -1.5455 0.4545 -0.5455 -> out

sum(x - mean(x)) -> in

-1.421085e-14 -> out

sum((x - mean(x)^2) -> in

28.72727 -> out

n <- 11
sum((x - mean(x)^2) / n -> in

2.61157 -> out

sum((x - mean(x))^2) / (n - 1) -> in

2.872727 -> out

var(x) # Variance -> in

2.872727 -> out

sd(x) # Standard deviation -> in

1.694912 -> out

* The interquartile range, or IQR, is the distance between the two numbers that cut-off the middle 50% of your data

summary(x) -> in

Min. 1st Qu. Median Mean 3rd Qu.
72.00  73.50     74.00 74.55     75.50 -> out

IQR(x) # Interquartile range -> in

2 -> out

x_new -> in

76 97 75 74 76 72 74 73 73 75 74 -> out

var(x_new) # Was 2.87 -> in

48.81818 -> out

sd(x_new) # Was 1.69 -> in

6.987001 -> out

diff(range(x_new)) # Was 6 -> in

25 -> out 

IQR(x_new) # Doesn"t change -> in

2 -> out
'

# Compute groupwise measures of spread
gap2007 %>%
  group_by(continent) %>%
  summarize(sd(lifeExp), IQR(lifeExp), n())

# Generate overlaid density plots
gap2007 %>%
  ggplot(aes(x = lifeExp, fill = continent)) +
  geom_density(alpha = 0.3)


# Compute stats for lifeExp in Americas
gap2007 %>%
  filter(continent == 'Americas') %>%
  summarize(mean(lifeExp),
            sd(lifeExp))

# Compute stats for population
gap2007 %>%
  summarize(median(pop), IQR(pop))


'
Shape and transformations
Modality
The modality of a distribution is the number of prominent humps that show up in the distribution.
- Unimodal
- Bimodal
- Multimodal
- Uniform

Skew
The skew is where the long tail is
- Right-skewed
- Left-skewed
- Symmetric

Shape of income
ggplot(life, aes(x=income, fill=west_coast)) + geom_density(alpha= 0.3)

ggplot(life, aes(x=log(income), fill=west_coast)) + geom_density(alpha= 0.3)
'

# Create density plot of old variable
gap2007 %>%
  ggplot(aes(x = pop)) +
  geom_density()

# Transform the skewed pop variable
gap2007 <- gap2007 %>%
  mutate(log_pop = log(pop))

# Create density plot of new variable
gap2007 %>%
  ggplot(aes(x = log_pop)) +
  geom_density()


'
Characteristics of a distribution
- Center
- Variability
- Shape
- Outliers

Outliers
These are observations that have extreme values far from the bulk of the distribution.

Indicating outliers
life <- life %>%
  mutate(is_outlier = income > 75000)

life %>%
  filter(is_outlier) %>%
  arrange(desc(income)) 

Plotting without outliers
life %>%
  filter(!is_outlier) %>%
  ggplot(aes(x=income, fill=west_coast)) + geom_density(alpha=0.3)
'

  # Filter for Asia, add column indicating outliers
gap_asia <- gap2007 %>%
  filter(continent == 'Asia') %>%
  mutate(is_outlier = lifeExp < 50)

# Remove outliers, create box plot of lifeExp
gap_asia %>%
  filter(!is_outlier) %>%
  ggplot(aes(x = 1, y = lifeExp)) +
  geom_boxplot()


' Case Study '

'
Introducing the data
Email dataset
email -> in

# A tibble: 3921 x 21
      spam  to_multiple    from      cc sent_mail                  time  image
      <fct>       <dbl>   <dbl>   <int>     <dbl>                <dttm>  <dbl>
1  not_spam           0       1       0         0   2012-01-01 01:16:41      0
2  not_spam           0       1       0         0   2012-01-01 02:03:59      0
3  not_spam           0       1       0         0   2012-01-01 11:00:32      0
4  not_spam           0       1       0         0   2012-01-01 04:09:49      0
5  not_spam           0       1       0         0   2012-01-01 05:00:01      0
6  not_spam           0       1       0         0   2012-01-01 05:04:46      0
7  not_spam           1       1       0         1   2012-01-01 12:55:06      0
8  not_spam           1       1       1         1   2012-01-01 13:45:21      1
9  not_spam           0       1       0         0   2012-01-01 16:08:59      0
10 not_spam           0       1       0         0   2012-01-01 13:12:00      0
# ... with 3,911 more rows, and 14 more variables: attach <dbl>,
# dollar <dbl>, winner <fct>, inherit <dbl>, viagra >dbl>,
# password <dbl>, num_char <dbl>, line_breaks <int>, format <dbl>,
# re_subj <dbl>, exclaim_subj <dbl>, urgent_subj <dbl>,
# exclaim_mess <dbl>, number <fct>    -> out

Histograms
ggplot(data, aes(x=var1)) + geom_histogram() + facet_wrap(~var2)

Boxplots
ggplot(data, aes(x=var2, y=var1)) + geom_boxplot()

Density plots
ggplot(data, aes(x=var1, fill=var2)) + geom_density(alpha=0.3)
'

# Load packages
library(ggplot2)
library(dplyr)
library(openintro)

# Compute summary statistics
email %>%
  group_by(spam) %>%
  summarize(median(num_char), IQR(num_char))

# Create plot
email %>%
  mutate(log_num_char = log(num_char)) %>%
  ggplot(aes(x = spam, y = log_num_char)) +
  geom_boxplot()


# Compute center and spread for exclaim_mess by spam
email %>%
  group_by(spam) %>%
  summarize(median(exclaim_mess),
            IQR(exclaim_mess))

# Create plot for spam and exclaim_mess
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + 0.01)) %>%
  ggplot(aes(x = log_exclaim_mess)) +
  geom_histogram() +
  facet_wrap(~ spam)

# Alternative plot: side-by-side box plots
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + 0.01)) %>%
  ggplot(aes(x = 1, y = log_exclaim_mess)) +
  geom_boxplot() +
  facet_wrap(~ spam)

# Alternative plot: Overlaid density plots
email %>%
  mutate(log_exclaim_mess = log(exclaim_mess + 0.01)) %>%
  ggplot(aes(x = log_exclaim_mess, fill = spam)) +
  geom_density(alpha = 0.3)


'
Check-in 1
Zero inflation strategies
- Analyze the two components separately
- Collapse into two-level categorical variable

email %>%
  mutate(zero = exclaim_mess == 0) %>%
  ggplot(aes(x=zero)) + geom_bar() + facet_wrap(~spam)

Bar chart options
email %>%
  mutate(zero = exclaim_mess == 0) %>%
  ggplot(aes(x=zero, fill=spam)) + geom_bar()

email %>%
  mutate(zero = exclaim_mess == 0) %>%
  ggplot(aes(x=zero, fill=spam)) + geom_bar(position='fill') # Normalize the plot
'

# Create plot of proportion of spam by image
email %>%
  mutate(has_image = image > 0) %>%
  ggplot(aes(x = has_image, fill = spam)) +
  geom_bar(position = 'fill')


# Test if images count as attachments
sum(email$image > email$attach)


# Question 1
email %>%
  filter(dollar > 0) %>%
  group_by(spam) %>%
  summarize(mean(dollar))

# Question 2
email %>%
  filter(dollar > 10) %>%
  ggplot(aes(x = spam)) +
  geom_bar()


'
Check-in 2
Ordering bars
email <- email %>%
  mutate(zero = exclaim_mess == 0)
levels(email$zero) -> in

NULL -> out

email$zero <- factor(email$zero, levels=c('TRUE', 'FALSE'))

email %>%
  ggplot(aes(x=zero)) + geom_bar() + facet_wrap(~spam)
'

# Reorder levels
email$number_reordered <- factor(email$number, levels=c("none", "small", "big"))

# Construct plot of number_reordered
ggplot(email, aes(x=number_reordered)) +
  geom_bar() +
  facet_wrap(~spam)