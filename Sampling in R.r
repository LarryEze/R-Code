' Introduction to Sampling '

'
Sampling and point estimates
Estimating the population of France
- A census asks every household how many people live there.
- Censuses are really expensive!

Sampling households
- Cheaper to ask a small number of households and use statistics to estimate the population
- Working with a subset of the whole population is called sampling

Population vs. sample
The population is the complete dataset
* Doesn"t have to refer to people
* Typically, don"t know what the whole population is

-The sample is the subset of data you calculate on

Coffee rating dataset
total_cup_points variety country_of origin aroma flavor aftertaste  body balance
90.58                 NA          Ethiopia  8.67   8.83       8.67  8.50    8.42
89.92              Other          Ethiopia  8.75   8.67       8.50  8.42    8.42
...                  ...               ...   ...    ...        ...   ...     ...
73.75                 NA           Vietnam  6.75   6.67       6.50  6.92    6.83

- Each row represents 1 coffee
- 1338 rows

Points vs flavor: population
pts_vs_flavor_pop <- coffee_ratings %>% select(total_cup_points, flavor)  -> in

    total_cup_points flavor
0              90.58   8.83
1              89.92   8.67
2              89.75   8.50
3              89.00   8.58
4              88.83   8.50
...              ...    ...
1333           78.75   7.58
1334           78.08   7.67
1335           77.17   7.33
1336           75.08   6.83
1337           73.75   6.67  -> out

dim(pts_vs_flavor_pop)  -> in

1338    2  -> out

Points vs flavor: 10 row sample
pts_vs_flavor_samp <- coffee_ratings %>% select(total_cup_points, flavor) %>% slice_sample(n = 10)  -> in

        total_cup_points  flavor
1                  82.25    7.58
2                  83.50    7.67
3                  80.50    7.17
4                  79.33    7.17
5                  83.83    7.58
6                  84.17    7.75
7                  83.67    8.17
8                  81.92    7.50
9                  82.67    7.58
10                 83.42    7.67  -> out

dim(pts_vs_flavor_samp)  -> in

10    2  -> out

Base-R sampling
* Use slice_sample() for data frames, and sample() for vectors.

cup_points_samp <- sample(coffee_ratings$total_cup_points, size = 10)  -> in

88.25 83.83 83.17 82.67 84.67 83.42 73.67 86.00 81.58 80.92  -> out

Population parameters & point estimates
A population parameter is a calculation made on the population dataset

mean(pts_vs_flavor_pop$total_cup_points)  -> in

82.15 -> out

A point estimate or sample statistic is a calculation made on the sample dataset

mean(cup_points_samp) -> in

82.82 -> out

Points estimates with dplyr
pts_vs_flavor_pop %>%
  summarize(mean_flavor = mean(flavor))  -> in

    mean_flavor
1         7.526  -> out

pts_vs_flavor_samp %>%
  summarize(mean_flavor = mean(flavor))  -> in

    mean_flavor
1         7.716  -> out
'

# View the whole population dataset
View(spotify_population)

# Sample 1000 rows from spotify_population
spotify_sample <- spotify_population %>%
  slice_sample(n = 1000)

# See the result
spotify_sample

# Calculate the mean duration in mins from spotify_population
mean_dur_pop <- spotify_population %>% summarize(mean_dur = mean(duration_minutes))

# Calculate the mean duration in mins from spotify_sample
mean_dur_samp <- spotify_sample %>% summarize(mean_dur = mean(duration_minutes))

# See the results
mean_dur_pop
mean_dur_samp


# Get the loudness column of spotify_population
loudness_pop <- spotify_population$loudness

# Sample 100 values of loudness_pop
loudness_samp <- sample(loudness_pop, size = 100)

# See the results
loudness_samp

# Calculate the standard deviation of loudness_pop
sd_loudness_pop <- sd(loudness_pop)

# Calculate the standard deviation of loudness_samp
sd_loudness_samp <- sd(loudness_samp)

# See the results
sd_loudness_pop
sd_loudness_samp


'
Convenience sampling
The Literary Digest election prediction
* Prediction: Landon get 57%; Roosevelt gets 43%
* Actual results: Landon got 38%; Roosevelt got 62%
* Sample not  representative of population, causing sample bias
* Collecting data by the easiest method is called convenience sampling (prone to sample bias) 

Finding the mean age of French people
* Survey 10 people at Disneyland Paris
* Mean age of 24.6 years
* Will this be a ood estimate for all of France?

How accurate was the survey?
Year Average French Age
1975               31.6
1985               33.6
1995               36.2
2005               38.9
2015               41.2

* 24.6 years is a poor estimate
* People who visit DIsneyland aren"t representative of the whole population

Convenience sampling coffee ratings
coffee_ratings %>% summarize(mean_cup_points = mean(total_cup_points))  -> in

    mean_cup_points
1             82.09  -> out

coffee_ratings_first10 <- coffee_ratings %>% slice_head(n = 10)

coffee_ratings_first10 %>% summarize(mean_cup_points = mean(total_cup_points))  -> in

    mean_cup_points
1              89.1  -> out

Visualizing selection bias
coffee_ratings %>% ggplot(aes(x = total_cup_points)) + geom_histogram(binwidth = 2)

coffee_ratings_first10 %>% ggplot(aes(x = total_cup_points)) + geom_histogram(binwidth = 2) + xlim(59, 91)

Visualizing selection bias for a random sample
coffee_ratings %>% slice_sample(n = 10) %>% ggplot(aes(x = total_cup_points)) + geom_histogram(binwidth = 2) + xlim(59, 91)
'

# Visualize the distribution of acousticness as a histogram with a binwidth of 0.01
ggplot(spotify_population, aes(x = acousticness)) + geom_histogram(binwidth = 0.01)

# Update the histogram to use spotify_mysterious_sample with x-axis limits from 0 to 1
ggplot(spotify_mysterious_sample, aes(acousticness)) +
  geom_histogram(binwidth = 0.01) + xlim(0, 1)


# Visualize the distribution of duration_minutes as a histogram with a binwidth of 0.5
ggplot(spotify_population, aes(x = duration_minutes)) + geom_histogram(binwidth = 0.5)

# Update the histogram to use spotify_mysterious_sample2 with x-axis limits from 0 to 15
ggplot(spotify_mysterious_sample2, aes(duration_minutes)) +
  geom_histogram(binwidth = 0.01) + xlim(0, 15)


'
Pseudo-random number generation
What does random mean?
{adjective} made, done, happening, or chosen without method or conscious decision.

True random numbers
- Generated from physical processes, like flipping coins
- Hotbits uses radioactive decay
- RANDOM.ORG uses atmospheric noise
* Available in R via the random package
- True randomness is expensive

Pseudo-random number generation
* Pseudo-random number generation is cheap and fast
* Next 'random' number is calculated from previous 'random' number
* The first 'random' number is calculated from a seed
* The same seed value yields the same random numbers

Pseudo-random number generation example
seed <- 1
calc_next_random(seed) -> in

3 -> out

calc_next_random(3) -> in

2 -> out

calc_next_random(2) -> in

6 -> out

Random number generating functions
Function            Distribution
rbeta               Beta
rbinomial           Binomial
rcauchy             Cauchy
rchisq              Chi-squared
rexp                Exponential
rf                  F
rgamma              Gamma
rgeom               Geometric
rhyper              Hypergeometric
rlnorm              Lognormal
rlogis              Logistic
rnbinom             Negative binomial
rnorm               Normal
rpois               Poisson
rsignrank           Wilcoxon signed rank
rt                  t
runif               Unifrom
rweibull            Weibull
rwilcox             Wilcoxon rank sum

Visualizing random numbers
rbeta(5000, shape1 = 2, shape2 = 2)  -> in

[1] 0.2788 0.7495 0.6485 0.6665 0.6546 0.1575
...

[4996] 0.84719 0.35177 0.92796 0.67603 0.53960  -> out

randoms <- data.frame(beta = rbeta(5000, shape1 = 2, shape2 = 2))  -> in

ggplot(randoms, aes(beta)) + geom_histogram(binwidth = 0.1)

Random numbers seeds
set.seed(20000229)

rnorm(5)  -> in

-1.6538 -0.4028 -0.1654 -0.0734 0.5171  -> out

rnorm(5)  -> in

1.908 0.379 -1.499 1.625 0.693  -> out

Using a different seed
set.seed(2041004)

rnorm(5)  -> in

-0.6547 -0.7854 -0.0152 0.1514 0.5285  -> out

rnorm(5)  -> in

0.748 0.974 0.174 -0.781 -0.930  -> out
'

args(runif)
args(rnorm)

# Generate random numbers from ...
randoms <- data.frame(
  # a uniform distribution from -3 to 3
  uniform = runif(n_numbers, min = -3, max = 3),
  # a normal distribution with mean 5 and sd 2
  normal = rnorm(n_numbers, mean = 5, sd = 2)
)

# Plot a histogram of uniform values, binwidth 0.25
ggplot(randoms, aes(uniform)) + geom_histogram(binwidth = 0.25)

# Plot a histogram of normal values, binwidth 0.5
ggplot(randoms, aes(normal)) + geom_histogram(binwidth = 0.5)


' Sampling Methods '

'
Simple random and systematic sampling
Simple random sampling in R
set.seed(19000113)

coffee_ratings %>% 
  slice_sample(n = 5)  -> in

    total_cup_points    variety     country_of_origin   aroma   flavor  aftertaste      body    balance
1              81.00       SL14                Uganda    7.33     6.92        7.17      7.42       7.42
2              85.00    Caturra              Colombia    8.00     7.92        7.75      7.75       7.83
3              85.25    Bourbon             Guatemala    8.00     7.92        7.75      7.92       7.83
4              81.42     Catuai             Guatemala    7.42     7.33        7.08      7.33       7.25
5              82.75    Caturra              Honduras    7.58     7.50        7.42      7.50       7.50  -> out

Adding a row ID column
library(tibble)
coffe_ratings <- coffee_ratings %>%
  rowid_to_column()  -> in

# A tibble: 1.338 x 9
    rowid   total_cup_points    variety     country_of origin   aroma   flavor  aftertaste       body   balance
    <int>              <dbl>      <chr>                 <chr>   <dbl>    <dbl>       <dbl>      <dbl>     <dbl>
1       1              90.6          NA              Ethiopia    8.67     8.83        8.67        8.5      8.42
2       2              89.9       Other              Ethiopia    8.75     8.67        8.5        8.42      8.42
3       3              89.8     Bourbon             Guatemala    8.42     8.5         8.42       8.33      8.42
4       4              89            NA              Ethiopia    8.17     8.58        8.42        8.5      8.25
5       5              88.8       Other              Ethiopia    8.25     8.5         8.25       8.42      8.33  -> out

Systematic sampling in R
sample_size <- 5
pop_size <- nrow(coffee_ratings)  -> in

1338 -> out

interval <- pop_size %/% sample_size  -> in

NB: ( %/% ) when used will return an integer division

267 -> out

Systematic sampling in R 2
row_indexes <- seq_len(sample_size) * interval  -> in

267 534 801 1068 1335  -> out

coffee_ratings %>%
  slice(row_indexes)  -> in

# A tibble: 5 x 9
    rowid   total_cup_points    variety     country_of_origin   aroma   flavor  aftertaste       body   balance
    <int>              <dbl>      <chr>                 <chr>   <dbl>    <dbl>       <dbl>      <dbl>     <dbl>
1     267               83.9         NA              Colombia    7.92     7.67        7.5        7.58      7.67
2     534               82.9    Bourbon                Brazil    7.67     7.58        7.5        7.58      7.5
3     801               82        Gesha                Malawi    7.5      7.42        7.33       7.33      7.5
4    1068               80.6         NA              Colombia    7.08     7.25        7          7.08      7.33
5    1335               78.1         NA               Ecuador    7.5      7.67        7.75       5.17      5.25  -> out

The trouble with systematic sampling
coffee_ratings %>% 
  ggplot(aes(x = rowid, y = aftertaste)) + 
  geom_point() + 
  geom_smooth()

- Systematic sampling is only safe if we don"t see a pattern in the data

Making systematic sampling safe
shuffled <- coffee_ratings %>% 
  slice_sample(prop = 1) %>% 
  select(- rowid) %>% 
  rowid_to_column()

shuffled %>%
  ggplot(aes(x = rowid, y = aftertaste)) + 
  geom_point() + 
  geom_smooth()

- Shuffling rows + systematic sampling is the same as simple random sampling 
'

# View the attrition_pop dataset
View(attrition_pop)

# Set the seed
set.seed(69)

attrition_samp <- attrition_pop %>% 
  # Add a row ID column
  rowid_to_column() %>% 
  # Get 200 rows using simple random sampling
  slice_sample(n = 200)

# View the attrition_samp dataset
View(attrition_samp)


# Set the sample size to 200
sample_size <- 200

# Get the population size from attrition_pop
pop_size <- nrow(attrition_pop)

# Calculate the interval
interval <- pop_size %/% sample_size

# Get row indexes for the sample
row_indexes <- seq_len(sample_size) * interval

attrition_sys_samp <- attrition_pop %>% 
  # Add a row ID column
  rowid_to_column() %>% 
  # Get 200 rows using systematic sampling
  slice(row_indexes)

# See the result
View(attrition_sys_samp)


# Add a row ID column to attrition_pop
attrition_pop_id <- attrition_pop %>% 
  rowid_to_column()

# Using attrition_pop_id, plot YearsAtCompany vs. rowid
ggplot(attrition_pop_id, aes(x = rowid, y = YearsAtCompany)) +
  # Make it a scatter plot
  geom_point() +
  # Add a smooth trend line
  geom_smooth()

# Shuffle the rows of attrition_pop then add row IDs
attrition_shuffled <- attrition_pop %>% 
  slice_sample(prop = 1) %>% 
  rowid_to_column()

# Using attrition_shuffled, plot YearsAtCompany vs. rowid
# Add points and a smooth trend line
ggplot(attrition_shuffled, aes(x = rowid, y = YearsAtCompany)) + geom_point() + geom_smooth()


'
Stratified and weighted random sampling
- It is a technique that allows us to sample a population that contains subgroups.

Coffees by country
top_counts <- coffee_ratings %>% 
  count(country_of_origin, sort = TRUE) %>% 
  head()

# A tibble: 6 x 2
        country_of_origin       n
                    <chr>   <int>
1  Mexico                     236
2  Colombia                   183
3  Guatemala                  181
4  Brazil                     132
5  Taiwan                      75
6  United States (Hawaii)      73  -> out

Filtering for 6 countries
top_counted_countries <- c('Mexico', 'Colombia', 'Guatemala', 'Brazil', 'Taiwan', 'United States (Hawaii)')

coffee_ratings_top <- coffee_ratings %>% 
  filter(country_of_origin %in% top_counted_countries)

Or, equivalently

coffee_ratings_top <- coffee_ratings %>% 
  semi_join(top_counts)

Counts of a simple random sample
coffee_ratings_samp <- coffee_ratings_top %>% 
  slice_sample(prop = 0.1)

coffee_ratings_samp %>% 
  count(country_of_origin, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))  -> in

# A tibble: 6 x 3
        country_of_origin       n   percent
                    <chr>   <int>     <dbl>
1  Guatemala                   24      27.3
2  Mexico                      23      26.1
3  Brazil                      12      13.6
4  Colombia                    11      12.5
5  Taiwan                       9      10.2
6  United States (Hawaii)       9      10.2  -> out

Proportional stratified sampling
coffee_ratings_strat <- coffee_ratings_top %>% 
  group_by(country_of_origin) %>% 
  slice_sample(prop = 0.1) %>%
  ungroup()

coffee_ratings_strat %>% 
  count(country_of_origin, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))  -> in

# A tibble: 6 x 3
        country_of_origin       n   percent
                    <chr>   <int>     <dbl>
1  Mexico                      23      26.7
2  Colombia                    18      20.9
3  Guatemala                   18      20.9
4  Brazil                      13      15.1
5  Taiwan                       7      8.14
6  United States (Hawaii)       7      8.14  -> out

Equal counts stratified sampling
coffee_ratings_eq <- coffee_ratings_top %>% 
  group_by(country_of_origin) %>% 
  slice_sample(n = 15) %>% 
  ungroup()

coffee_ratings_eq %>% 
  count(country_of_origin, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))  -> in

# A tibble: 6 x 3
        country_of_origin       n   percent
                    <chr>   <int>     <dbl>
1  Brazil                      15      16.7
2  Colombia                    15      16.7
3  Guatemala                   15      16.7
4  Mexico                      15      16.7
5  Taiwan                      15      16.7
6  United States (Hawaii)      15      16.7  -> out

Weighted random sampling
* Specify weights to adjust the relative probability of a row being sampled

coffee_ratings_weight <- coffee_ratings_top %>% 
  mutate(weight = ifelse(country_of_origin == 'Taiwan', 2, 1)) %>% 
  slice_sample(prop = 0.1, weight_by = weight)

coffee_ratings_weight %>% 
  count(country_of_origin, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))  -> in

# A tibble: 6 x 3
        country_of_origin       n   percent
                    <chr>   <int>     <dbl>
1  Mexico                      23      26.1
2  Guatemala                   20      22.7
3  Taiwan                      15      17.0
4  Brazil                      12      13.6
5  Colombia                    10      11.4
6 United States (Hawaii)        8      9.09  -> out
'

education_counts_pop <- attrition_pop %>% 
  # Count the employees by Education level, sorting by n
  count(Education, sort = TRUE) %>% 
  # Add a percent column
  mutate(percent = 100 * n / sum(n))

# See the results
education_counts_pop

# Use proportional stratified sampling to get 40% of each Education group
attrition_strat <- attrition_pop %>% 
  group_by(Education) %>% 
  slice_sample(prop = 0.4) %>%
  ungroup()

# See the result
attrition_strat

# Get the counts and percents from attrition_strat
education_counts_strat <- attrition_strat %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))

# See the results
education_counts_strat


# Use equal counts stratified sampling to get 30 employees from each Education group
attrition_eq <- attrition_pop %>% 
  group_by(Education) %>% 
  slice_sample(n = 30) %>% 
  ungroup()

# See the results
attrition_eq

# Get the counts and percents from attrition_eq
education_counts_eq <- attrition_eq %>% 
  count(Education, sort = TRUE) %>% 
  mutate(percent = 100 * n / sum(n))

# See the results
education_counts_eq


# Using attrition_pop, plot YearsAtCompany as a histogram with binwidth 1
ggplot(attrition_pop, aes(x = YearsAtCompany)) + geom_histogram(binwidth = 1)

# Sample 400 employees weighted by YearsAtCompany
attrition_weight <- attrition_pop %>% 
  slice_sample(n = 400, weight_by = YearsAtCompany)

# See the results
attrition_weight

# Using attrition_weight, plot YearsAtCompany as a histogram with binwidth 1
ggplot(attrition_weight, aes(x = YearsAtCompany)) + geom_histogram(binwidth = 1)


'
Cluster sampling
Stratified sampling vs. cluster sampling
- Stratified sampling
* Split the population into subgroups
* Use simple random sampling on every subgroup

- Cluster sampling
* Use simple random sampling to pick some subgroups
* Use simple random sampling on only those subgroups

Varieties of coffee
varieties_pop <- unique(coffee_ratings$variety)  -> in

[1] 'Bourbon'
[2] 'Catimor'
[3] 'Ethiopian Yirgacheffe'
[4] 'Caturra'
[5] 'SL14'
...
[27] 'Marigojipe'
[28] 'Pache Comun'  -> out

Stage 1: sampling for subgroups
varieties_samp <- sample(varieties_pop, size = 3) -> in

'Sumatra'    'Blue Mountain'    'SL28'  -> out

Stage 2: sampling each group
coffee_ratings %>% 
  filter(variety %in% varieties_samp) %>% 
  group_by(variety) %>%
  slice_sample(n = 5) %>%
  ungroup()

Stage 2 output
# A tibble: 10 x 8
    total_cup_points        variety     country_of_origin   aroma   flavor  aftertaste       body   balance
            <dbl>             <chr>                 <chr>   <dbl>    <dbl>       <dbl>      <dbl>     <dbl>
1              81.5   Blue Mountain                 Haiti    7.42     7.33        7.25       7.42      7.33
2              82.7   Blue Mountain                Mexico    7.75     7.58        7.25       7.67      7.58
3              84.5            SL28                 Kenya    7.92     7.83        7.67       7.67      7.75
4              81.9            SL28                Zambia    7.67     7.08        7.42       7.75      7.42
5              84.7            SL28                 Kenya    7.75     7.92        7.83       7.58      7.75
6              85.5            SL28                 Kenya    7.92     7.92        7.83       7.83      7.92
7              83.8            SL28                 Kenya    7.75     7.58        7.5        7.75      7.75
8              86.6         Sumatra                Taiwan    8        8           8          8         8.17
9              81.7         Sumatra             Indonesia    7.17     7.42        7.33       7.33      7.42
10             83.5         Sumatra             Indonesia    7.25     7.67        7.58       7.83      7.58  -> out

Multistage sampling
- Cluster sampling is a type of multistage sampling
- Can have > 2 stages
- E.g., countrywide surveys may sample states, countries, cities and neighborhoods
'

# Get unique JobRole values
job_roles_pop <- unique(attrition_pop$JobRole)

# Randomly sample four JobRole values
job_roles_samp <- sample(job_roles_pop, size = 4)

# See the result
job_roles_samp

# Filter for rows where JobRole is in job_roles_samp
attrition_filtered <- attrition_pop %>%
  filter(JobRole %in% job_roles_samp)

# Randomly sample 10 employees from each sampled job role
attrition_clus <- attrition_filtered %>%
  group_by(JobRole) %>%
  slice_sample(n = 10) %>%
  ungroup()

# See the result
attrition_clus


'
Comparing sampling methods
Review of sampling techniques
Setup
top_counted_countries <- c('Mexico', 'Colombia', 'Guatemala', 'Brazil', 'Taiwan', 'United States (Hawaii)')

coffee_ratings_top <- coffee_ratings %>% 
   filter(country_of_origin %in% top_counted_countries)

Simple random sampling
coffee_ratings_srs <- coffee_ratings_top %>% 
  slice_sample(prop = 1/3)

Stratified sampling
coffee_ratings_strat <- coffee_ratings_top %>%
  group_by(country_of_origin) %>%
  slice_sample(prop = 1/3)  %>%
  ungroup()

Cluster sampling
top_countries_samp <- sample(top_counted_countries, size = 2)

coffee_ratings_clust <- coffee_ratings_top %>%
  filter(country_of_origin %in% top_countries_samp) %>%
  group_by(country_of_origin) %>%
  slice_sample(n = nrow(coffee_ratings_top) / 6) %>%
  ungroup()


Calculating mean cup points
Population
coffee_ratings_top %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

81.9  -> out

Simple random sample
coffee_ratings_srs %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

82.0  -> out

Stratified sample
coffee_ratings_strat %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

81.8  -> out

Cluster sample
coffee_ratings_clust %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

81.2  -> out


Mean cup points by country
Population:
coffee_ratings_top %>% 
  group_by(country_of_origin %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

# A tibble: 6 x 2
country_of_origin   mean_points
<chr>  <dbl>
1  Brazil                  82.4
2  Colombia                83.1
3  Guatemala               81.8
4  Mexico                  80.9
5  Taiwan                  82.0
6  United States (Hawaii)  81.8  -> out

Simple random sample
coffee_ratings_srs %>% 
  group_by(country_of_origin %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

# A tibble: 6 x 2
country_of_origin   mean_points
<chr>  <dbl>
1  Brazil                  82.3
2  Colombia                83.1
3  Guatemala               81.5
4  Mexico                  81.1
5  Taiwan                  82.8
6  United States (Hawaii)  82.7  -> out

Stratified sample
coffee_ratings_strat %>% 
  group_by(country_of_origin %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

# A tibble: 6 x 2
country_of_origin   mean_points
<chr>  <dbl>
1  Brazil                  82.4
2  Colombia                82.9
3  Guatemala               81.7
4  Mexico                  80.7
5  Taiwan                  82.3
6  United States (Hawaii)  81.2  -> out

Cluster sample
coffee_ratings_clust %>% 
  group_by(country_of_origin %>% 
  summarize(mean_points = mean(total_cup_points))  -> in

# A tibble: 2 x 2
country_of_origin   mean_points
<chr>  <dbl>
1  Mexico                  80.8
2  Taiwan                  82.0  -> out
'

# Perform simple random sampling to get 0.25 of the population
attrition_srs <- attrition_pop %>% 
  slice_sample(prop = 0.25)

# Perform stratified sampling to get 0.25 of each relationship group
attrition_strat <- attrition_pop %>%
  group_by(RelationshipSatisfaction) %>%
  slice_sample(prop = 0.25) %>%
  ungroup()

# Get unique values of RelationshipSatisfaction
satisfaction_unique <- unique(attrition_pop$RelationshipSatisfaction)

# Randomly sample for 2 of the unique satisfaction values
satisfaction_samp <- sample(satisfaction_unique, size = 2)

# Perform cluster sampling on the selected group getting 0.25 of the population
attrition_clust <- attrition_pop %>%
  filter(RelationshipSatisfaction %in% satisfaction_samp) %>%
  group_by(RelationshipSatisfaction) %>%
  slice_sample(n = nrow(attrition_pop) / 4) %>%
  ungroup()


# Use the whole population dataset 
mean_attrition_pop <- attrition_pop %>% 
  # Group by relationship satisfaction level
  group_by(RelationshipSatisfaction) %>% 
  # Calculate the proportion of employee attrition
  summarize(mean_attrition = mean(Attrition == 'Yes'))

# See the result
mean_attrition_pop

# Calculate the same thing for the simple random sample 
mean_attrition_srs <- attrition_srs %>% 
  group_by(RelationshipSatisfaction) %>% 
  summarize(mean_attrition = mean(Attrition == 'Yes'))

# See the result
mean_attrition_srs

# Calculate the same thing for the stratified sample 
mean_attrition_strat <- attrition_strat %>% 
  group_by(RelationshipSatisfaction) %>% 
  summarize(mean_attrition = mean(Attrition == 'Yes'))

# See the result
mean_attrition_strat

# Calculate the same thing for the cluster sample 
mean_attrition_clust <- attrition_clust %>% 
  group_by(RelationshipSatisfaction) %>% 
  summarize(mean_attrition = mean(Attrition == 'Yes'))

# See the result
mean_attrition_clust


' Sampling Distributions '

'
Relative error of point estimates
Sample size is number of rows
coffee_ratings %>%
  slice_sample(n = 300) %>%
  nrow()  -> in

300 -> out

coffee_ratings %>%
  slice_sample(prop = 0.25) %>%
  nrow()  -> in

334 -> out

Various sample sizes
coffee_ratings %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)  -> in

82.15  -> out

coffee_ratings %>%
  slice_sample(n = 10) %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)  -> in

82.82  -> out

coffee_ratings %>%
  slice_sample(n = 100) %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)  -> in

82.02  -> out

coffee_ratings %>%
  slice_sample(n = 1000) %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)  -> in

82.16  -> out

Relative errors
Population parameter:
population_mean <- coffee_ratings %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)

Point estimate:
sample_mean <- coffee_ratings %>%
  slice_sample(n = sample_size) %>%
  summarize(mean_points = mean(total_cup_points)) %>%
  pull(mean_points)

Relative error as a percentage:
rel_error_pct = 100 * abs(populaion_mean - sample_mean) / population_mean

Relative error vs sample size
ggplot(errors, aes(sample_size, relative_error)) + geom_line() + geom_smooth(method = 'loess')

Properties:
* Really noisy, particulrly for small samples
* Amplitude is initially steep, then flattens
* Relative error decreases to zero (when the sample size = population)
'

# Generate a simple random sample of 10 rows 
attrition_srs10 <- attrition_pop %>%
  slice_sample(n = 10) 

# Calculate the proportion of employee attrition in the sample
mean_attrition_srs10 <- attrition_srs10 %>%
  summarize(mean_attrition_pop = mean(Attrition == 'Yes')) %>%
  pull(mean_attrition_pop)

# Calculate the relative error percentage
rel_error_pct10 <- 100 * abs(attrition_srs10 - mean_attrition_srs10) /attrition_srs10

# See the result
rel_error_pct10

# Calculate the relative error percentage again with a sample of 100 rows
attrition_srs100 <- attrition_pop %>%
  slice_sample(n = 100) 

# Calculate the proportion of employee attrition in the sample
mean_attrition_srs100 <- attrition_srs100 %>%
  summarize(mean_attrition_pop = mean(Attrition == 'Yes')) %>%
  pull(mean_attrition_pop)

rel_error_pct100 <- 100 * abs(attrition_srs100 - mean_attrition_srs100) /attrition_srs100

# See the result
rel_error_pct100


'
Creating a sampling distribution
Same code, different answer
coffee_ratings %>%
  slice_sample(n = 30) %>%
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points)  -> in

82.33  -> out

coffee_ratings %>%
  slice_sample(n = 30) %>%
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points)  -> in

82.59  -> out

coffee_ratings %>%
  slice_sample(n = 30) %>%
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points)  -> in

82.16 -> out

coffee_ratings %>%
  slice_sample(n = 30) %>%
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points)  -> in

82.25 -> out

Same code, 1000 times
mean_cup_points_1000 <- replicate(n = 1000, expr = coffee_ratings %>%
  slice_sample(n = 30) %>%
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points))  -> in

  [1] 81.65 81.57 82.66 82.27 81.76 81.74 82.71
  [8] 82.20 80.43 82.45 82.29 82.63 82.28 82.11
 [15] 82.14 81.72 81.97 82.58 81.78 82.47 81.73
 [22] 82.78 82.14 82.39 81.69 82.36 82.64 82.68
 [29] 82.56 82.14 82.72 82.43 81.68 82.74 82.80
 [36] 82.12 82.31 81.02 82.83 81.71 82.25 82.11
 [43] 82.76 82.26 81.57 82.00 81.75 81.47 81.99
 [50] 82.68 82.05 82.43 82.40 82.66 80.78 82.43
 ...
[967] 81.84 83.12 81.54 81.83 82.24 82.36 82.49
[974] 82.05 82.08 81.98 82.45 82.04 81.42 83.06
[981] 81.97 82.65 81.12 82.48 81.64 81.92 81.96
[988] 81.71 81.96 81.78 82.30 81.76 82.46 82.43
[995] 81.95 82.60 81.84 82.78 82.23 82.56  -> out

Preparing for plotting
library(tibble)
sample_means <- tibble(sample_mean = mean_cup_points_1000)

Distribution of sample means for size 30
ggplot(sample_means, aes(sampe_mean)) + geom_histogram(binwidth = 0.1)

- A sampling distribution is a distribution of several replicates of point estimates.
'

# Replicate this code 500 times
mean_attritions <- replicate(
  n = 500,
  expr = attrition_pop %>% 
    slice_sample(n = 20) %>% 
    summarize(mean_attrition = mean(Attrition == "Yes")) %>% 
    pull(mean_attrition))

# See the result
head(mean_attritions)

# Store mean_attritions in a tibble in a column named sample_mean
sample_means <- tibble(sample_mean = mean_attritions)

# Plot a histogram of the `sample_mean` column, binwidth 0.05
ggplot(sample_means, aes(sample_mean)) + geom_histogram(binwidth = 0.05)


'
Approximate sampling distributions
4 dice
dice <- expand_grid(die1 = 1:6, die2 = 1:6, die3 = 1:6, die4 = 1:6)  -> in

# A tibble: 1296 x 4
    die1     die2    die3    die4
    <int>   <int>   <int>   <int>
1       1       1       1       1
2       1       1       1       2
3       1       1       1       3
4       1       1       1       4
5       1       1       1       5
6       1       1       1       6
7       1       1       2       1
8       1       1       2       2
9       1       1       2       3
10      1       1       2       4
# ... with 1,286 more rows  -> out

Mean roll
dice <- expand_grid(die1 = 1:6, die2 = 1:6, die3 = 1:6, die4 = 1:6) %>%
  mutate(mean_roll = (die1 + die2 + die3 + die4) / 4)  -> in

# A tibble: 1296 x 5
    die1     die2    die3    die4  mean_roll
    <int>   <int>   <int>   <int>      <dbl>
1       1       1       1       1      1
2       1       1       1       2      1.25
3       1       1       1       3      1.5
4       1       1       1       4      1.75
5       1       1       1       5      2.
6       1       1       1       6      2.25
7       1       1       2       1      1.25
8       1       1       2       2      1.5
9       1       1       2       3      1.75
10      1       1       2       4      2
# ... with 1,286 more rows  -> out

Exact sampling distribution
ggplot(dice, aes(factor(mean_roll))) + geom_bar()

The number of outcomes increases fast
outcomes <- tibble(n_dice = 1:100, n_outcomes = 6 ^ n_dice)     

ggplot(outcomes, aes(n_dice, n_outcomes)) + geom_point()

Simulating the mean of four dice rolls
sample_means_1000 <- replicate(n = 1000, expr = { four_rolls <- sample(1:6, size = 4, replace = TRUE) mean(four_rolls) })  -> in

sample_means <- tibble(sample_mean = sample_means_1000)  -> in

# A tibble: 1,000 x 1
    sample_mean
        <dbl>
1         4
2         4.5
3         2.5
4         3.75
5         3.75
6         4
7         3
8         4.75
9         3.75
10        4.25
# ... 990 more rows  -> out

Approximate sampling distribution
ggplot(sample_means, aes(factor(sample_mean))) + geom_bar()
'

# Expand a grid representing 5 8-sided dice
dice <- expand_grid(
  die1 = 1:8,
  die2 = 1:8,
  die3 = 1:8,
  die4 = 1:8,
  die5 = 1:8
) %>% 
  # Add a column of mean rolls
  mutate(mean_roll = (die1 + die2 + die3 + die4 + die5) / 5)

# Using dice, draw a bar plot of mean_roll as a factor
ggplot(dice, aes(factor(mean_roll))) + geom_bar()


# Sample one to eight, five times, with replacement
five_rolls <- sample(1:8, size = 5, replace = TRUE) 

# Calculate the mean of five_rolls
mean(five_rolls)


# Replicate the sampling code 1000 times
sample_means_1000 <- replicate(
  n = 1000,
  expr = {
    five_rolls <- sample(1:8, size = 5, replace = TRUE)
    mean(five_rolls)
  }
)

# See the result
sample_means_1000

# Wrap sample_means_1000 in the sample_mean column of a tibble
sample_means <- tibble(sample_mean = sample_means_1000)

# See the result
sample_means

# Using sample_means, draw a bar plot of sample_mean as a factor
ggplot(sample_means, aes(factor(sample_mean))) + geom_bar()


'
Standard errors and the Central Limit Theorem
Consequences of the central limit theorem
- Averages of independent samples have approximately normal distributions.

- As the sample size increases,
* The distribution of the averages gets closer to being normally distributed
* the width of the sampling distribution gets narrower

Population & sampling distribution means
coffee_ratings %>% 
  summarize(mean_cup_points = mean(total_cup_points)) %>%
  pull(mean_cup_points)  -> in

82.1512 -> out

Sample size  Mean sample mean
5                     82.1496
20                    82.1610
80                    82.1496
320                   82.1521

Population & sampling distribution standard deviations
coffee_ratings %>% 
  summarize(sd_cup_points = sd(total_cup_points)) %>%
  pull(sd_cup_points)  -> in

2.68686  -> out

Sample size  Std dev sample mean
5                         1.1929
20                        0.6028
80                        0.2865
320                       0.1304

Population mean over square root sample size
Sample size     Std dev sample mean           Calculation       Result
5                            1.1929     2.68686 / sqrt(5)       1.2016
20                           0.6028    2.68686 / sqrt(20)       0.6008
80                           0.2865    2.68686 / sqrt(80)       0.3004
320                          0.1304   2.68686 / sqrt(320)       0.1502

Result = Estimate of the Std dev of the sampling distribution for the sample size
'

# Calculate the mean across replicates of the mean attritions in sampling_distribution_5
mean_of_means_5 <- sampling_distribution_5 %>%
  summarize(mean_mean_attrition = mean(mean_attrition))

# Do the same for sampling_distribution_50
mean_of_means_50 <- sampling_distribution_50 %>%
  summarize(mean_mean_attrition = mean(mean_attrition))

# ... and for sampling_distribution_500
mean_of_means_500 <- sampling_distribution_500 %>%
  summarize(mean_mean_attrition = mean(mean_attrition))

# See the results
mean_of_means_5
mean_of_means_50
mean_of_means_500

# For comparison: the mean attrition in the population
attrition_pop %>% 
  summarize(mean_attrition = mean(Attrition == "Yes"))


# Calculate the standard deviation across replicates of the mean attritions in sampling_distribution_5
sd_of_means_5 <- sampling_distribution_5 %>%
  summarize(sd_mean_attrition = sd(mean_attrition))

# Do the same for sampling_distribution_50
sd_of_means_50 <- sampling_distribution_50 %>%
  summarize(sd_mean_attrition = sd(mean_attrition))

# ... and for sampling_distribution_500
sd_of_means_500 <- sampling_distribution_500 %>%
  summarize(sd_mean_attrition = sd(mean_attrition))

# See the results
sd_of_means_5
sd_of_means_50
sd_of_means_500

# For comparison: population standard deviation
sd_attrition_pop <- attrition_pop %>% 
  summarize(sd_attrition = sd(Attrition == "Yes")) %>% 
  pull(sd_attrition)

# The sample sizes of each sampling distribution
sample_sizes <- c(5, 50, 500)


' Bootstrap Distributions '

'
Introduction to bootstrapping
With or without
Sampling without replacement e.g deck of Cards distribution

Sampling with replacement ('resampling') e.g Rolling dice

Why sample with replacement?
- coffee_ratings: The dataset is a sample of a larger population of all coffees
- Each coffee in our sample represents many different hypothetical population coffeess
- Sampling with replaceement is a proxy

Coffee data preparation
coffee_focus <- coffee_ratings %>%
  select(variety, country_of_origin, flavor) %>%
  rowid_to_column()

glimpse(coffee_focus)  -> in

Rows: 1,338
Columns: 4
$ rowid                 <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, ...
$ variety               <chr> NA, 'Other', 'Bourbon', NA, 'Other', NA, 'Other', ...
$ country_of_origin     <chr> 'Ethiopia', 'Ethiopia', 'Guatemala', 'Ethiopia', ...
$ flavor                <dbl> 8.83, 8.67, 8.50, 8.58, 8.50, 8.42, 8.50, 8.33, ...  -> out

Resampling with slice_sample()
coffee_resamp <- coffee_focus %>%
  slice_sample(prop = 1, replace = True)  -> in

    rowid      variety      country_of_origin   flavor
1    1253      Bourbon              Guatemala     6.92
2     186      Caturra               Colombia     7.58
3    1185      Bourbon              Guatemala     7.42
4    1273           NA            Philippines     6.5
5    1042      Caturra               Honduras     7.33
6     195      Caturra              Guatemala     7.75
7    1219       Typica                 Mexico     7
8     952      Caturra               Honduras     7.5
9      41      Caturra               Thailand     8.33
10    460      Caturra               Honduras     7.67
# ... with 1,338 more rows  -> out

repeated coffees
coffee_resamp %>%
  count(rowid, sort = TRUE)  -> in

# A tibble: 844 x 2
    rowid       n
    <int>   <int>
1     704       5
2     913       5
3    1070       5
4      16       4
5     180       4
6     230       4
7     234       4
8     342       4
9     354       4
10    423       4
# ... with 834 more rows  -> out

Missing coffees
coffee_resamp %>%
  summarize(coffees_included = n_distinct(rowid), coffees_not_included = n() - coffees_included)  -> in

# A tibble: 1 x 2
    coffees_included    coffees_not_included
            <int>                      <int>
1                844                     494  -> out

Bootstrapping
Its the opposite of sampling from a population
- Sampling: going from a population to a smaller sample
- Bootstrapping:  building up a theoretical population from the sample

Bootstrapping use case:
- Develop understanding of sampling variability using a single sample

Bootstrapping process
1. Make a resample (randomly sample with replacement) of the same size as the original sample
2. Calculate the statistic of interest (e.g mean etc) for this bootstrap sample
3. Repeat steps 1 and 2 many times
The resulting statistics are bootstrap statistics, and they form a bootstrap distribution

Bootstrapping coffee mean flavor
# Step 3. Repeat many times
mean_flavors_1000 <- replicate(
  n = 1000,
  expr = {
    coffee_focus %>%
    # Step 1. Resample
    slice_sample(prop = 1, replace = TRUE) %>%
    # Step 2. Calculate statistic
    summarize(mean_flavor = mean(flavor, na.rm = TRUE)) %>%
    pull(mean_flavor)
})

Bootstrap distribution histogram
bootstrap_distn <- tibble(resample_mean = mean_flavors_1000)

ggplot(bootstrap_distn, aes(resample_mean)) + geom_histogram(binwidth = 0.0025)
'

# Generate 1 bootstrap resample
spotify_1_resample <- spotify_sample %>%
  slice_sample(prop = 1, replace = TRUE)

# See the result
spotify_1_resample

# Calculate mean danceability of resample
mean_danceability_1 <- spotify_1_resample %>%
  summarize(mean_danceability = mean(danceability)) %>%
  pull(mean_danceability)

# See the result
mean_danceability_1


# Replicate this 1000 times
mean_danceability_1000 <- replicate(
  n = 1000,
  expr = {
    spotify_1_resample <- spotify_sample %>% 
      slice_sample(prop = 1, replace = TRUE)
    spotify_1_resample %>% 
      summarize(mean_danceability = mean(danceability)) %>% 
      pull(mean_danceability)
  }
)

# See the result
mean_danceability_1000

# Store the resamples in a tibble
bootstrap_distn <- tibble(
  resample_mean = mean_danceability_1000
)

# Draw a histogram of the resample means with binwidth 0.002
ggplot(bootstrap_distn, aes(resample_mean)) + geom_histogram(binwidth = 0.002)


'
Comparing sampling and bootstrap distributions
The bootstrap of mean coffee flavors
mean_flavors_1000 <- replicate(
  n = 1000,
  expr = coffee_sample %>% 
      slice_sample(prop = 1, replace = TRUE) %>% 
      summarize(mean_flavor = mean(flavor, na.rm = TRUE)) %>% 
      pull(mean_flavor)
  )

bootstrap_distn <- tibble(resample_mean = mean_flavors_1000)

Mean flavor bootstrap distribution
ggplot(bootstrap_distn, aes(resample_mean)) + geom_histogram(binwidth = 0.0025)

Sample, bootstrap distribution, population means
Sample mean:
coffee_sample %>%
  summarize(mean_flavor = mean(flavor)) %>%
  pull(mean_flavor)  -> in

7.5163  -> out

True population mean:
coffee_ratings %>%
  summarize(mean_flavor = mean(resample_mean)) %>%
  pull(mean_flavor)  -> in

7.5260 -> out

Estimated population mean:
bootstrap_distn %>%
  summarize(mean_mean_flavor = mean(resample_mean)) %>%
  pull(mean_mean_flavor)  -> in

7.5167  -> out

Interpreting the means
Bootstrap distribution mean:
- They are usually close to the sample mean
- They may not be a good estimate of the popultion mean
- Bootstrapping cannot correct biases from sampling

Sample sd vs bootstrap distribution sd
Sample standard deviation:
coffee_focus %>%
  summarize(sd_flavor = sd(flavor)) %>%
  pull(sd_flavor)  -> in

0.3525  -> out

Estimated population standard deviation:
bootstrap_distn %>%
  summarize(sd_mean_flavor = sd(resample_mean)) %>%
  pull(sd_mean_flavor)  -> in

0.01572  -> out

-Standard error is the standard deviation of the statistic of interest

std = standard_error * sqrt(500) -> in

0.3515  -> out

- Standard error times square root of sample size estimates the population standard deviation

True standard deviation:
coffee_ratings %>%
  summarize(sd_flavor = sd(flavor)) %>%
  pull(sd_flavor)  -> in

0.3414  -> out

Interpreting the standard errors
* Estimated standard error is the standard deviation of the bootstrap distribution for a sample statistic
* Population std. dev = Std. Error x sqrt(Sample size)
'

# Generate a sampling distribution
mean_popularity_2000_samp <- replicate(
  # Use 2000 replicates
  n = 2000,
  expr = {
    # Start with the population
    spotify_population %>% 
      # Sample 500 rows without replacement
      slice_sample(n = 500) %>% 
      # Calculate the mean popularity as mean_popularity
      summarize(mean_popularity = mean(popularity)) %>% 
      # Pull out the mean popularity
      pull(mean_popularity)
  }
)

# See the result
mean_popularity_2000_samp

# Generate a bootstrap distribution
mean_popularity_2000_boot <- replicate(
  # Use 2000 replicates
  n = 2000,
  expr = {
    # Start with the sample
    spotify_sample %>% 
      # Sample same number of rows with replacement
      slice_sample(n = 500, replace = TRUE) %>% 
      # Calculate the mean popularity
      summarize(mean_popularity = mean(popularity)) %>% 
      # Pull out the mean popularity
      pull(mean_popularity)
  }
)

# See the result
mean_popularity_2000_boot


# Calculate the true population mean popularity
pop_mean <- spotify_population %>%
  summarize(mean_popularity = mean(popularity))

# Calculate the original sample mean popularity
samp_mean <- spotify_sample %>%
  summarize(mean_popularity = mean(popularity))

# Calculate the sampling dist'n estimate of mean popularity
samp_distn_mean <- sampling_distribution %>%
  summarize(mean_popularity = mean(sample_mean))

# Calculate the bootstrap dist'n estimate of mean popularity
boot_distn_mean <- bootstrap_distribution %>%
  summarize(mean_popularity = mean(resample_mean))

# See the results
c(pop = pop_mean, samp = samp_mean, sam_distn = samp_distn_mean, boot_distn = boot_distn_mean)


# Calculate the true popluation std dev popularity
pop_sd <- spotify_population %>%
  summarize(sd_popularity = sd(popularity))

# Calculate the true sample std dev popularity
samp_sd <- spotify_sample %>%
  summarize(sd_popularity = sd(popularity))

# Calculate the sampling dist'n estimate of std dev popularity
samp_distn_sd <- sampling_distribution %>%
  summarize(sd_popularity = sd(sample_mean) * sqrt(500))

# Calculate the bootstrap dist'n estimate of std dev popularity
boot_distn_sd <- bootstrap_distribution %>%
  summarize(sd_popularity = sd(resample_mean) * sqrt(500))

# See the results
c(pop = pop_sd, samp = samp_sd, sam_distn = samp_distn_sd, boot_distn = boot_distn_sd)


'
Confidence intervals
- 'Values within one standard deviation of the mean' includes a large number of values from each of these distributions
- We"ll define a related concept called a confidence interval

Predicting the weather
- Rapid City, South Dakota in the United States has the least predictable weather
- Predict the high temperature there tomorrow

Our weather prediction
- Point estimate = 47F(8.3C)
- Range of plausible high temperature values = 40 to 54F (4.4 to 12.8C)

We just reported a confidence interval!
- 40 to 54F is a confidence interval
- Sometimes written as 47F (40F, 54F) or 47F [40F, 54F]
- ... or, 47 +- 7F
- 7F is the margin of error

Bootstrap distribution of mean flavor
ggplot(coffee_boot_distn, aes(resample_mean)) + geom_histogram(binwidth = 0.002)

Mean of the resamples
coffee_boot_distn %>%
  summarize(mean_resample_mean = mean(resample_mean))  -> in

# A tibble: 1 x 1
    mean_resample_mean
                <dbl>
1               7.5263  -> out

Mean plus or minus one standard deviation
coffee_boot_distn %>%
  summarize(
    mean_resample_mean = mean(resample_mean), 
    mean_minus_1sd = mean_resample_mean - sd(resample_mean), 
    mean_plus_1sd =  mean_resample_mean + sd(resample_mean)
)  -> in

# A tibble: 1 x 3
    mean_resample_mean    mean_plus_1sd   mean_minus_1sd
                <dbl>             <dbl>            <dbl>
1               7.5263           7.5355           7.5171  -> out

Quantile method for confidence intervals
coffee_boot_distn %>%
  summarize(
    lower = quantile(resample_mean, 0.025), 
    upper = quantile(resample_mean, 0.975)
)  -> in

# A tibble: 1 x 2
    lower       upper
    <dbl>       <dbl>
1  7.5087      7.5447 -> out

Inverse cumulative distribution function
- PDF: the bell curve
- CDF: using calculus to integrate to get area under bell curve
- Inverse CDF: flip x and y axes

normal_inv_cdf <- tibble(p = seq(-0.001, 0.999, 0.001), inv_cdf = qnorm(p))

ggplot(normal_inv_cdf, aes(p, inv_cdf)) + geom_line()

Standard error method for confidence interval
coffee_boot_distn %>%
  summarize(point_estimate = mean(resample_mean), std_error = sd(resample_mean), lower = qnorm(0.025, point_estimate, std_error), upper = qnorm(0.975, point_estimate, std_error))  -> in

# A tibble: 1 x 4
    point_estimate      std_error   lower   upper
            <dbl>           <dbl>   <dbl>   <dbl>
1           7.5263      0.0091815  7.5083  7.5443  -> out
'

# Generate a 95% confidence interval using the quantile method
conf_int_quantile <- bootstrap_distribution %>% 
  summarize(
    lower = quantile(resample_mean, 0.025),
    upper = quantile(resample_mean, 0.975)
    )

# See the result
conf_int_quantile


# Generate a 95% confidence interval using the std error method
conf_int_std_error <- bootstrap_distribution %>% 
  summarize(
    point_estimate = mean(resample_mean),
    standard_error = sd(resample_mean),
    lower = qnorm(0.025, point_estimate, standard_error), 
    upper = qnorm(0.975, point_estimate, standard_error)
  )

# See the result
conf_int_std_error