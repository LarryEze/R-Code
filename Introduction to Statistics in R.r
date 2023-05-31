' Summary Statistics '

'
What is statistics?
- The field of statistics : The practice and study of collecting and analyzing data
- A summary statistuc : A fact about or summary of some data

What can statistics do?
- How likely is someone to purchase a product? Are people more likely to purchase it if they can use a different payment system?
- How many occupants will your hotel have? How can you optimize occupancy?
- How many sizes of jeans need to be manufactured so they can fit 95% of the population? Should the same number of each size be produced?
- A/B tetst: Which as is more effective in getting people to purchase a product?

What can"t statistics do?
- Why is Game of Thrones so popular?
Instead...
- Are series with more violent scenes viewed by more people?
But...
- Even so, this can"t tehh us if more violent scenes lead to more views

Types of statistics
Descriptive statistics
- It describe and summarize data
* 50% of friends drive to work
* 25% take te bus
* 25% bike

Inferential statistics
- It uses a sample of data to make inferences about a larger population
* What percent of people drive to work?

Types of data
Numeric (Quantitative)
- It is made up of numeric values

Continuous (Measured)
* Airplane speed
* Time spent waiting in line

Discrete (Counted)
* Number of pets
* Number of packages shipped

Categorical (Qualitative)
- It is made p of values that belong to distinct groups.

Nominal (Unordered)
* Married / unmarried
* Country of residence

Ordinal (Ordered)
* Strongly disagree
* Somewhat disagree
* Neither agree nor disagree
* Somewhat agree
* Strongly agree

Categorical data can be represented as numbers
Nominal (Unordered)
* Married / unmarried ( 1 / 0 )
* Country of residence ( 1, 2, ... )

Ordinal (Ordered)
* Strongly disagree ( 1 ) 
* Somewhat disagree ( 2 )
* Neither agree nor disagree ( 3 )
* Somewhat agree ( 4 )
* Strongly agree ( 5 )

Why does data type matter?
Numeric data
Summry statistics
car_speeds %>%
  summarize(avg_speed = mean(speed_mph))    -> in

    avg_speed
1    40.09062   -> out

Plots
- Scatter plot

Categorical data
Summry statistics
demographics %>%
  count(marriage_status)    -> in

    marriage_status      n
1            single    188
2           married    143
3          divorced    124

Plots
- Bar plot
'


'
Measures of center
Histograms
- It takes a bunch of data points and separates them into bins, or ranges of values.

Measures of center: mean
- It is often called the average and is one of the most common ways of summarizing data.
e.g
mean(msleep$sleep_total) -> in

10.43373 -> out

Measures of center: median
- It is the value where 50% of the data is lower than it, and 50% of the data is higher.
e.g
median(msleep$sleep_total) -> in

10.1 -> out

Measures of center: mode
- It is the most frequent value in the data
e.g
msleep %>%
  count(sleep_total, sort=TRUE) -> in

    sleep_total        n
        <dbl>      <int>
1         12.5         4
2         10.1         3
3          5.3         2
4          6.3         2
...         -> out

msleep %>%
  count(vore, sort=TRUE) -> in

        vore          n
        <chr>     <int>
1       herbi        32
2        omni        20
3       carni        19
4          NA         7
5     insecti         5
...       -> out

Adding an outlier
msleep %>%
  filter(vore == 'insecti') %>%
  summarize(mean_sleep = mean(sleep_total), median_sleep = median(sleep_total)) -> in

    mean_sleep  median_sleep
        <dbl>          <dbl>
1       16.52           18.9     -> out

NB:
* Mean is much more sensitive to extreme values than the median.
* Mean works better for symmetrical data
* Median is better to use for skewed data.
'

# Filter for Belgium
belgium_consumption <- food_consumption %>%
  filter(country == 'Belgium')

# Filter for USA
usa_consumption <- food_consumption %>%
  filter(country == 'USA')

# Calculate mean and median consumption in Belgium
mean(belgium_consumption$consumption)
median(belgium_consumption$consumption)

# Calculate mean and median consumption in USA
mean(usa_consumption$consumption)
median(usa_consumption$consumption)

food_consumption %>%
  # Filter for Belgium and USA
  filter(country %in% c("Belgium", "USA")) %>%
  # Group by country
  group_by(country) %>%
  # Get mean_consumption and median_consumption
  summarize(mean_consumption = mean(consumption), median_consumption = median(consumption))


food_consumption %>%
  # Filter for rice food category
  filter(food_category == 'rice') %>%
  # Create histogram of co2_emission
  ggplot(aes(co2_emission)) + geom_histogram()

food_consumption %>%
  # Filter for rice food category
  filter(food_category == "rice") %>%
  # Create histogram of co2_emission
  ggplot(aes(co2_emission)) +
    geom_histogram()

food_consumption %>%
  # Filter for rice food category
  filter(food_category == "rice") %>% 
  # Get mean_co2 and median_co2
  summarize(mean_co2 = mean(co2_emission), median_co2 = median(co2_emission))


'
Measures of spread?
What is spread?
- It describes how spread apart or close together the data points are.

Variance
- It measures the average distance from each data point to the data"s mean
- The higher the variance, the more spread out the data is
- The values of variance are in square (i.e ^2)
e.g
var(msleep$sleep_total) -> in

19.80568 -> out

Standard deviation
- It is calculated by taking the square root of the variance
- The units are usually easier to understand since they"re not squared.
e.g
sd(msleep$sleep_total) -> in

4.450357 -> out

Mean absolute deviation
- It takes the absolute value of the distances to the mean, and then takes the mean of those differences

Standard deviation vs mean absolute deviation
- SD squares distances, penalizing longer distances more than shorter ones
- MAD penalizes each distance equally
- One isn"t better than the other, but SD is more common than MAD.

Quartiles
- It splits up the data into four equal parts 
e.g
quantile(msleep$sleep_total) -> in

0%      25%     50%     75%     100%
1.90    7.85    10.10   13.75   19.90 -> out

Second quartile / 50th percentile = median

Boxplots use quartiles
ggplot(msleep, aes(y = sleep_total)) + geom_boxplot()

- The bottom of the box is the first quartile
- The top of the box is the third quartile
- The middle line is the second quartile, or the median.

Quantiles
quantile(msleep$sleep_total, probs=c(0, 0.2, 0.4, 0.6, 0.8, 1)) -> in

0%      20%     40%     60%     80%     100%
1.90    6.24    9.48    11.14   14.40   19.90 -> out

seq(from, to, by)
quantile(msleep$sleep_total, probs=seq(0, 1, 0.2)) -> in

0%      20%     40%     60%     80%     100%
1.90    6.24    9.48    11.14   14.40   19.90 -> out

Interquartile range (IQR)
- Height of the box in a boxplot

quantile(msleep$sleep_total, 0.75) - quantile(msleep$sleep_total, 0.25) -> in

75%
5.9    -> out

Outliers
Outlier: data poit that is substantially different from the others
How do we know what a substantial difference is? A data point is an outlier if:
* data < Q1 - 1.5 x IQR or
* data > Q3 + 1.5 x IQR

Finding outliers
iqr <- quantile(msleep$bodywt, 0.75) - quantile(msleep$bodywt, 0.25)
lower_threshold <- quantile(msleep$bodywt, 0.25) - 1.5 * iqr
upper_threshold <- quantile(msleep$bodywt, 0.75) + 1.5 * iqr

msleep %>%
  filter(bodywt < lower_threshold | bodywt > upper_threshold) %>%
  select(name, vore, sleep_total, bodywt) -> in

# A tibble: 11 x 4
            name        vore  sleep_total    bodywt
            <chr>       <chr>       <dbl>     <dbl>
1              Cow      herbi           4       600
2   Asian elephant      herbi         3.9      2547
3            Horse      herbi         2.9       521
...     -> out
'

# Calculate the quartiles of co2_emission
quantile(food_consumption$co2_emission)

# Calculate the quintiles of co2_emission
quantile(food_consumption$co2_emission, probs=seq(0, 1, 0.2))

# Calculate the deciles of co2_emission
quantile(food_consumption$co2_emission, probs=seq(0, 1, 0.1))


# Calculate variance and sd of co2_emission for each food_category
food_consumption %>% 
  group_by(food_category) %>% 
  summarize(var_co2 = var(co2_emission), sd_co2 = sd(co2_emission))

# Plot food_consumption with co2_emission on x-axis
ggplot(food_consumption, aes(x=co2_emission)) +
  # Create a histogram
  geom_histogram() +
  # Create a separate sub-graph for each food_category
  facet_wrap(~ food_category)


# Calculate total co2_emission per country: emissions_by_country
emissions_by_country <- food_consumption %>%
  group_by(country) %>%
  summarize(total_emission = sum(co2_emission))

# Compute the first and third quartiles and IQR of total_emission
q1 <- quantile(emissions_by_country$total_emission, 0.25)
q3 <- quantile(emissions_by_country$total_emission, 0.75)
iqr <- q3 - q1

# Calculate the lower and upper cutoffs for outliers
lower <- q1 - 1.5 * iqr
upper <- q3 + 1.5 * iqr

# Filter emissions_by_country to find outliers
emissions_by_country %>%
  filter(emissions_by_country$total_emission > upper | emissions_by_country$total_emission < lower)


' Random Numbers and Probability '

'
What are the chances?
- of closing a sale?
- of rain tomorrow?
- of winning a game?

Measuring chance
We can measure the chances of an event using probability.

what"s the probability of an  event?
P(event) = No of ways event can happen / Total No of possible outcomes

Example: a cpoin flip
P(heads) = 1 way to get heads / 2 possible outcomes = 1 / 2 = 50%

* Probability is always between zero ( 0 ) and 100%

Sampling from a data frame
sales_counts -> in

    name    n_sales
1   Amir    178
2  Brian    126
3 Claire    75
4 Damian    69 -> out

sales_counts %>%
  sample_n(1) -> in

    name    n_sales
1  Brian    126 -> out

sales_counts %>%
  sample_n(1) -> in

    name    n_sales
1 Claire    75 -> out

Setting a random seed
The seed is a number that R"s random number generator uses as a starting point, so, if we orient it with a seed number, it will generate the same random value each time.
e.g
set.seed(5)
sales_counts %>%
  sample_n(1) -> in

    name    n_sales
1  Brian    126 -> out

Sampling with replacement in R
sales_counts %>%
  sample_n(2, replace=TRUE) -> in

    name    n_sales
1  Brian    126
2 Claire    75 -> out

sample(sales_team, 5, replace=TRUE) -> in

    name    n_sales
1  Brian    126
2 Claire    75 
3  Brian    126
4  Brian    126
5   Amir    178 -> out

Independent events
Two events are independent if the propbability of the second event isn"t affected by the outcome of the first event.
i.e 
sampling with replacement = each pick is independent

Dependent events
Two events are dependent if the propbability of the second event is affected by the outcome of the first event.
i.e 
sampling without replacement = each pick is dependent
'

# Calculate probability of picking a deal with each product
amir_deals %>%
  count(product) %>%
  mutate(prob = n / sum(n))


# Set random seed to 31
set.seed(31)

# Sample 5 deals without replacement
amir_deals %>%
  sample_n(5)

# Set random seed to 31
set.seed(31)

# Sample 5 deals with replacement
amir_deals %>%
  sample_n(5, replace=TRUE)


'
Discrete distributions (Die Rolls)
Probability distribution
It describes the probability of each possible outcome in a scenario,
* Expected value : It is the mean of a probability distribution
e.g
Expected value of a fair die roll = (1 x 1/6) + (2 x 1/6) + (3 x 1/6) + (4 x 1/6) + (5 x 1/6) + (6 x 1/6) = 3.5

Probability = area
P(die roll) <= 2 = 1/6 + 1/6 = 1/3

Uneven die
if there"s no number 2 and number 3 appears twice instead

Expected value of uneven die roll = (1 x 1/6) + (2 x 0) + (3 x 1/3) + (4 x 1/6) + (5 x 1/6) + (6 x 1/6) = 3.67

P( uneven die roll) <= 2 = 1/6 + 0 = 1/6

* Fair die roll = Discrete uniform distribution

Sampling from discrete distributions
die -> in

    n
1   1
2   2
3   3
4   4
5   5
6   6 -> out

mean(die$n) -> in

3.5 -> out

rolls_10 <- die %>%
  sample_n(10, replace=TRUE)
rolls_10 -> in

    n
1   1
2   1
3   5
4   2
5   1
6   1
7   6
8   6
...  -> out

Visualizing a sample
ggplot(rolls_10, aes(n)) + geom_histogram(bins=6)

mean(rolls_10$n) = 3.0 

Law of large numbers
As the size of the sample increases, the sample mean will approach the expected value
i.e
Sample size     Mean
10              3.00
100             3.36
1000            3.53
'

# Create a histogram of group_size
ggplot(restaurant_groups, aes(x=group_size)) + geom_histogram(bins=5)

# Create probability distribution
size_distribution <- restaurant_groups %>%
  count(group_size) %>%
  mutate(probability = n / sum(n))

# Calculate expected group size
expected_val <- sum(size_distribution$group_size * size_distribution$probability)
expected_val

# Calculate probability of picking group of 4 or more
size_distribution %>%
  # Filter for groups of 4 or larger
  filter(group_size >= 4) %>%
  # Calculate prob_4_or_more by taking sum of probabilities
  summarize(prob_4_or_more = sum(probability))


'
Continuous distributions (wait time)
Probability still = area
max wait time = 12
P(4 <= wait time <= 7) = (7 - 4) x 12 = 3/12

Uniform distribution in R
P(wait time <= 7) 
punif(7, min=0, max=12) -> in

0.5833333 -> out

lower.tail
P(wait >= 7)
punif(7, min=0, max=12, lower.tail=FALSE)  -> in

0.4166667 -> out

P(4 <= wait time <= 7) = P(wait <= 7) - P(wait <= 4) 
punif(7, min=0, max=12) - punif(4, min=0, max=12)  -> in

0.25 -> out

Total area = 1
P(0 <= outcome <= 12) = 12 x 1/12 = 1 

* The area beneath a continuous distribution must always equal 1 e.g Normal distribution & Poisson distribution
'

# Min and max wait times for back-up that happens every 30 min
min <- 0
max <- 30

# Calculate probability of waiting less than 5 mins
prob_less_than_5 <- punif(5, min, max)
prob_less_than_5

# Calculate probability of waiting more than 5 mins
prob_greater_than_5 <- punif(5, min, max, lower.tail=FALSE)
prob_greater_than_5

# Calculate probability of waiting 10-20 mins
prob_between_10_and_20 <- punif(20, min, max) - punif(10, min, max)
prob_between_10_and_20


# Set random seed to 334
set.seed(334)

# Generate 1000 wait times between 0 and 30 mins, save in time column
wait_times %>%
  mutate(time = runif(1000, min = 0, max = 30)) %>%
  # Create a histogram of simulated times
  ggplot(aes(x=time)) + geom_histogram(bins=30)


'
The binomial distribution (Coin flipping)
Binary outcomes
This is an outcome with two possible values.
The outcomes can also be represented as 1 and 0, success or failure, win or loss.

A single flip
rbinom(No of trials, No of coins, Probability of heads / success)

1=heads, 0=tails

rbinom(1, 1, 0.5) -> in

1 -> out

rbinom(1, 1, 0.5) -> in

0 -> out

One flip many times
8 flips of 1 coin with 50% chance os success
rbinom(8, 1, 0.5) -> in

1 0 0 1 0 0 1 0 -> out

Many flips one time
1 flip of 8 coins with 50% chance os success
rbinom(1, 8, 0.5) -> in

3 -> out

Many flips many times
10 flips of 3 coin with 50% chance os success
rbinom(10, 3, 0.5) -> in

2 0 1 0 1 1 3 3 3 1 -> out

Other probabilities
Head = 25%
Tail = 75%

rbinom(10, 3, 0.25) -> in

1 1 0 0 1 1 1 1 2 1 -> out

Binomial distribution
It describes the probability distribution of the number of successes in a sequence of independent trials.
e.g
Number of heads in a sequence of coin flips
Described by n and p
- n: total number of trials
- p: probability of success

rbinom(3, n, p)
rbinom(3, 10, 0.5)

What"s the probability of 7 heads?
P(heads = 7)

# dbinom(No of heads, No of trials, Probability of heads / success)
dbinom(7, 10, 0.5) -> in

0.1171875 -> out

What"s the probability of 7 or fewer heads?
P(heads <= 7)
pbinom(7, 10, 0.5) -> in

0.9453125 -> out

What"s the probability of more than 7 heads?
P(heads > 7)
pbinom(7, 10, 0.5, lower.tail=FALSE) -> in

0.0546875 -> out

1 - pbinom(7, 10, 0.5) -> in

0.0546875 -> out

Expected value
Expected value = n x p

Expected number of heads out of 10 flips = 10 x 0.5 = 5

Independence
The binomial distribution is a probability distribution of the number of successes in a sequence of independent trials
* If trials are not independent, the binomial distribution does not apply!
'

# Set random seed to 10
set.seed(10)

# Simulate a single deal
rbinom(1, 1, 0.3)

# Simulate 1 week of 3 deals
rbinom(1, 3, 0.3)

# Simulate 52 weeks of 3 deals
deals <- rbinom(52, 3, 0.3)

# Calculate mean deals won per week
mean(deals)


# Probability of closing 3 out of 3 deals
dbinom(3, 3, 0.3)

# Probability of closing <= 1 deal out of 3 deals
pbinom(1, 3, 0.3)

# Probability of closing > 1 deal out of 3 deals
pbinom(1, 3, 0.3, lower.tail=FALSE)


# Expected number won with 30% win rate
won_30pct <- 3 * 0.3
won_30pct

# Expected number won with 25% win rate
won_25pct <- 3 * 0.25
won_25pct

# Expected number won with 35% win rate
won_35pct <- 3 * 0.35
won_35pct


' More Distributions and the Central Limit Theorem '

'
The normal distribution
What is the normal distribution?
- Its shape is commonly referred to as a 'bell curve'

Symmetrical
It is symmetrical i.e the left side is a mirror image of the right

Area = 1
Just like any continuous distribution, the area beneath the curve is 1.

Curve never hits 0
The probability never hits 0, even if it looks like it at the tail ends. (only 0.006% of its area is contained beyond the edges of the graph)

Described by mean and standard deviation
It is described by its mean and standard deviation.
* when a normal distribution has a mean 0 and a standard deviation of 1, it"s a special distribution called the standard normal distribution.

Areas under the normal distribution
- 68% of the area is within 1 standard deviation of the mean.
- 95% of the area falls within 2 standard deviations of the mean
- 99.7% of the area falls within 3 standard deviations
* It is sometimes called the 68-95-99.7 rule.

Women"s heights from NHANES
mean height = 161cm
standard deviation = 7cm

What percentage of women are shorter than 154cm?
pnorm(154, mean=161, sd=7) -> in

0.159 -> out

What percentage of women are taller than 154cm?
pnorm(154, mean=161, sd=7, lower.tail=FALSE) -> in

0.8413447 -> out

What percentage of women are 154-157 cm?
pnorm(157, mean=161, sd=7) - pnorm(154, mean=161, sd=7) -> in

0.1252 -> out

What height are 90% of women shorter than?
qnorm(0.9, mean=161, sd=7) -> in

169.9709 -> out

What height are 90% of women taller than?
qnorm(0.9, mean=161, sd=7, lower.tail=FALSE) -> in

152.03 -> out

Generating random numbers
# Generate 10 random heights
rnorm(10, mean=161, sd=7) -> in

159.35 157.34 149.85 156.75 163.53 156.33 157.22 171.44 158.10 170.12 -> out
'

# Histogram of amount with 10 bins
ggplot(amir_deals, aes(x=amount)) + geom_histogram(bins=10)


# Probability of deal < 7500
pnorm(7500, mean=5000, sd=2000)

# Probability of deal > 1000
pnorm(1000, mean=5000, sd=2000, lower.tail=FALSE)

# Probability of deal between 3000 and 7000
pnorm(7000, mean=5000, sd=2000) - pnorm(3000, mean=5000, sd=2000)

# Calculate amount that 75% of deals will be more than
qnorm(0.75, mean=5000, sd=2000, lower.tail=FALSE)


# Calculate new average amount
new_mean <- (5000 * 0.2) + 5000

# Calculate new standard deviation
new_sd <- (2000 * 0.3) + 2000

# Simulate 36 sales
new_sales <- new_sales %>% 
  mutate(amount = rnorm(36, mean=new_mean, sd=new_sd))

# Create histogram with 10 bins
ggplot(new_sales, aes(x=amount)) + geom_histogram(bins=10)


'
The central limit theorem
* sample_n() is used when sampling data.frame
* sample() is used when sampling vectors

Rolling the dice 5 times
die <- c(1, 2, 3, 4, 5, 6)

# Roll 5 times
sample_of_5 <- sample(die, 5, replace=TRUE)
sample_of_5 -> in

1 3 4 1 1 -> out

mean(sample_of_5) -> in

2.0 -> out

# Roll 5 times and take mean
sample(die, 5, replace=TRUE) %>% mean() -> in

4.4 -> out

sample(die, 5, replace=TRUE) %>% mean() -> in

3.8 -> out

Rolling the dice 5 times 10 times
Repeat 10 times:
* Roll 5 times
* Take the mean

sample_means <- replicate(10, sample(die, 5, replace=TRUE) %>% mean())
sample_means -> in

3.8 4.0 3.8 3.6 3.2 4.8 2.6 3.0 2.6 2.0 -> out

Sampling distribution
It is a distribution of a summary statistic e.g of the sample mean

Central Limit Theorem
It states that the sampling distribution will approach a normal distribution as the number of trials increases.
NB: The central limit theorem only applies when samples are taken randomly and are independent, for example, randomly picking sales deals with replacement.
- The central limit theorem applies to other summary statistics as well.

Standard deviation and the CLT
replicate(1000, sample(die, 5, replace=TRUE) %>% sd()

Proportions and the CLT
sales_team <- c('Amir', 'Brian', 'Claire', 'Damian')
sample(sales_team, 10, replace=TRUE) -> in

'Claire', 'Brian', 'Brian', 'Brian', 'Damian'. 'Damian', 'Brian', 'Brian', 'Amir', 'Amir' -> out

sample(sales_team, 10, replace=TRUE) -> in

'Amir', 'Amir', 'Claire', 'Amir', 'Amir', 'Brian', 'Amir', 'Claire', 'Claire', 'Claire'  -> out

Mean of sampling distribution
# Estimate expected value of die
mean(sample_means) -> in

3.48 -> out

# Estimate proportion of 'Claire's
mean(sample_props) -> in

0.26 -> out

- It can be a useful methof for estimating characteristics of an underlying distribution.
- More easily estimate characteristics of large populations
'

# Create a histogram of num_users
ggplot(amir_deals, aes(x=num_users)) + geom_histogram(bins=10)

# Set seed to 104
set.seed(104)

# Sample 20 num_users from amir_deals and take mean
sample(amir_deals$num_users, size = 20, replace = TRUE) %>%
  mean()

# Repeat the above 100 times
sample_means <- replicate(100, sample(amir_deals$num_users, size = 20, replace = TRUE) %>% 
  mean())

# Create data frame for plotting
samples <- data.frame(mean = sample_means)

# Histogram of sample means
ggplot(samples, aes(x=mean)) + geom_histogram(bins=10)


# Set seed to 321
set.seed(321)

# Take 30 samples of 20 values of num_users, take mean of each sample
sample_means <- replicate(30, sample(all_deals$num_users, 20) %>% 
  mean())

# Calculate mean of sample_means
mean(sample_means)

# Calculate mean of num_users in amir_deals
mean(amir_deals$num_users)


'
The Poisson distribution
Poisson processes
It is a process where events appear to happen at a certain rate, but completely at random.
e.g
- Number of animals adopted from an animal shelter per week
- Number of people arriving at a restaurant per hour
- Number of earthquakes in California per year

Poisson distribution
It describes the probability of some number of events happening over a fixed period of time.
e,g
- Probability of >= 5 animals adopted from an animal shelter per week
- Probability of 12 people arriving at a restaurant per hour
- Probability of < 20 earthquakes in California per year

Lambda
The poisson distribution is described by a value called lambda, which represents the average number of events per time period. 
- Lambda changes the shape of the distribution. so a Poisson distribution with lambda equals 1 looks quite different than a Poisson distribution with lambda equals 8, but no matter what, the distribution"s peak is always at its lambda value

Lambda = average number of events per time interval
* Average number of adoptions per week (Expected value) = 8

Probability of a single value
If the average number of adoptions per week is 8, what is P(No of adoptions in a week = 5)?

dpois(5, lambda=8) -> in

0.09160366 -> out

Probability of less than or equal to
If the average number of adoptions per week is 8, what is P(No of adoptions in a week <= 5)?

ppois(5, lambda=8) -> in

0.1912361 -> out

Probability of greater than
If the average number of adoptions per week is 8, what is P(No of adoptions in a week > 5)?

ppois(5, lambda=8, lower.tail=FALSE) -> in

0.8087639 -> out

If the average number of adoptions per week is 10, what is P(No of adoptions in a week > 5)?

ppois(5, lambda=10, lower.tail=FALSE) -> in

0.932914 -> out

Sampling from a Poisson distribution
rpois(10, lambda=8) -> in

13 6 11 7 10 8 7 3 7 6 -> out
'

# Probability of 5 responses
dpois(5, lambda=4)

# Probability of 5 responses from coworker
dpois(5, lambda=5.5)

# Probability of 2 or fewer responses
ppois(2, lambda=4)

# Probability of > 10 responses
ppois(10, lambda=4, lower.tail=FALSE)


'
More probability distributions
Exponential distribution
It represents the probability of a certain time passing between Poisson events.
e.g
- Probability of >1 day between adoptions
- Probability of <10 minutes between restaurant arrivals
- Probability of 6-8 months between earthquakes
* It also uses lambda (rate)
* Continuous data (time)

Customer service requests
- On average, one customer service ticket is created every 2 minutes
Lambda = 0.5 customer service tickets created each minute

Lambda in exponential distribution
The rate affects the shape of the distribution and how steeply it declines.

How long until a new request is created?
P(wait < 1 min) = pexp(1, rate=0.5) -> in

0.3934693 -> out

P(wait > 4 min) = pexp(4, rate=0.5, lower.tail=FALSE) -> in

0.1353353 -> out

P(1 min < wait < 4 min) = pexp(4, rate=0.5) - pexp(1, rate=0.5) -> in

0.4711954 -> out

Expected value of exponential distribution
In terms of rate (Poisson):
Lambda = 0.5 requests per minute

In terms of time (exponential):
1 / Lambda = 1 request per 2 minutes

(Student"s) t-distribution
It has similar shape as the normal distribution, but not quite the same. 

Degrees of freedom
- The t-distribution has a parameter called degrees of freedom (df) which affects the thickness of the tails
- Lower df = thicker tails and higher standard deviation
- Higher df = the distribution looks closer to a normal distribution.

Log-normal distribution
Variables that follow a log-normal distribution have a logarithm that is normally distributed.
This results in distributions that are skewed, unlike the normal distribution.
e.g
- Length of chess games
- Adult blood pressure
- Number of hospitalizations in the 2003 SARS outbreak
'

# Probability response takes < 1 hour
pexp(1, rate=1/2.5)

# Probability response takes > 4 hours
pexp(4, rate=1/2.5, lower.tail=FALSE)

# Probability response takes 3-4 hours
pexp(4, rate=1/2.5) - pexp(3, rate=1/2.5)


' Correlation and Experimental Design '

'
Correlation
Relationships between two variables
- It can be visualized using scatterplots
- x axis variable = explanatory / independent variable
- y axis variable = response / dependent variable

Correlation coefficient
- It can be used to quantify the linear relationship between two variables
- It is a number between -1 and 1
- The magnitude corresponds to the strength of the relationship
- The sign ( + or - ) corresponds to direction of relationship

Magnitude = strength of relationship
- 0.99 (very strong relationship)
- 0.75 (strong relationship)
- 0.56 (moderate relationship)
- 0.21 (weak relationship)
- 0.04 (no relationship) i.e knowning the value of x doesn"t tell us anything about y

Sign = direction
- 0.75 : as x increases, y increases
- -0.75 : as x increases, y decreases

Visualizing relationships
ggplot(df, aes(x, y)) + geom_point()

Adding a trendline
ggplot(df, aes(x, y)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

- method = 'lm' : To indicate that we want a linear trendline 
- se = FALSE : So there aren"t error margins around the line.

Computing correlation
cor(df$x, df$y) -> in

-0.7472765 -> out (correlation coefficient)

NB: It doesn"t matter which order the vectors are passed into the function since the correlation between x and y is the same thing as the correlation between y and x.

cor(df$y, df$x) -> in

-0.7472765 -> out (correlation coefficient)

Correlation with missing values
df$x -> in

-3.2508382 -9.1599807 3.4515013 4.1505899       NA 11.9806140 ... -> out

cor(df$x, df$y) -> in

NA -> out

cor(df$x, df$y, use='pairwise.complete.obs') -> in (use='pairwise.complete.obs' : used to ignore NA values)

-0.7471757 -> out

Many ways to calculate correlation
- Used in this course: Pearson product-moment correlation (r)
* It is the most commonly used method of correlation
* There are variations in the formula that measure correlation a bit differently, such as Kendall's tau and Spearman's rho

NB: The correlation coefficient measures the strength of linear relationships, and linear relationships only
'

# Add a linear trendline to scatterplot
ggplot(world_happiness, aes(life_exp, happiness_score)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Correlation between life_exp and happiness_score
cor(world_happiness$life_exp, world_happiness$happiness_score)


'
Correlation caveats
Non-linear relationships
- Correlation only accounts for linear relationships
* Correlation shouldn"t be used blindly
* Always visualize the data

Body weight vs awake time
cor(msleep$bodywt, msleep$awake) -> in

0.3119801 -> out

Log transformation
- It can be applied to highly skewed data

msleep %>%
  mutate(log_bodywt = log(bodywt)) %>%
  ggplot(aes(log_bodywt, awake)) + geom_point() + geom_smooth(method='lm', se=FALSE)

cor(msleep$log_bodywt, msleep$awake) -> in

0.5687943 -> out

Other transformations
- Log transformation ( log(x) )
- Square root tranformation ( sqrt(x) )
- Reciprocal transformation ( 1 / x )
- Combinations of these, e.g.:
* log( x ) and log( y )
* sqrt( x ) and 1 / y 

Why use a transformation?
- Certain statistical methods rely on variables having a linear relationship
* Correlation coefficient
* Linear regression

Correlation does not imply causation
x is correlated with y does not mean x causes y

Confounding
- A phenomenon called confounding can lead to spurious correlations.
'

# Scatterplot of gdp_per_cap and life_exp
ggplot(world_happiness, aes(gdp_per_cap, life_exp)) +
  geom_point()

# Correlation between gdp_per_cap and life_exp
cor(world_happiness$gdp_per_cap, world_happiness$life_exp)


# Scatterplot of happiness_score vs. gdp_per_cap
ggplot(world_happiness, aes(x=gdp_per_cap, y=happiness_score)) + geom_point()

# Calculate correlation
cor(world_happiness$gdp_per_cap, world_happiness$happiness_score)

# Create log_gdp_per_cap column
world_happiness <- world_happiness %>%
  mutate(log_gdp_per_cap = log(gdp_per_cap))

# Scatterplot of happiness_score vs. log_gdp_per_cap
ggplot(world_happiness, aes(x=log_gdp_per_cap, y=happiness_score)) +
  geom_point()

# Calculate correlation
cor(world_happiness$log_gdp_per_cap, world_happiness$happiness_score)


# Scatterplot of grams_sugar_per_day and happiness_score
ggplot(world_happiness, aes(x=grams_sugar_per_day, y=happiness_score)) + geom_point()

# Correlation between grams_sugar_per_day and happiness_score
cor(world_happiness$grams_sugar_per_day, world_happiness$happiness_score)


'
Design of experiments
Vocabulary
Experiment aims to answer: What is the effect of the treatment on the response?
- Treatment: explanatory / independent variable
- Response: response / dependent variable
e.g
What is the effect of an advertisement on the number of products purchased?
- Treatment: Advertisement
- Response: number of products purchased

Controlled experiments
- Participants are assigned by researchers to either treatment group or control group
* Treatment group sees advertisement
* Control group does not
- Groups should be comparable so that causation can be inferred
- If groups are not comparable, this could lead to confounding (bias)
* Treatment group average age: 25
* Control group average age: 50
* Age is a potential confounder

The gold tandard of experiments will use...
- Randomized controlled trial
* Participants are assigned to treatment / control randomly, not based on any other characteristics
* Choosing randomly helps ensure that groups are comparable
- Placebo
* Resembles treatment, but has no effect
* Participants will not know which group they're in
* In clinical trials, a sugar pill ensures that the effect of the drug is actually due to the drug itself and not the idea of receiving the drug
- Double-blind trial
* Person administering the treatment / running the study doen't know whether the treatment is real or a placebo
* Prevents bias in the response and  / or analysis of results

Fewer opportunities for bias = more reliable conclusion about causation

Observational studies
- Participants are not assigned randomly to groups
* PArticipants assign themselves, usually based on pre-existing characteristics
- Many research questions are not conducive to a controlled experiment
* You can't force someone to smoke or have a disease
* You can't make someone have certain past behaviour
- Establish association, not causation
* Effects can be confounded by factors that got certain people into the control or treatment group
- There are ways to control for confounders to get more reliable conclusions about association

Longitudinal vs cross-sectional studies
Longitudinal study
- Participants are followed over a period of time to examine effect of treatment on response
- Effect of age on height is not confounded by generation
- More expensive, results take longer

Cross-sectional study
- Data on participants is collected from a single snapshot in time
- Effect of age on height is confounded by generation
- Cheaper, faster, more convenient.
'