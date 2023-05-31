' Introduction to Hypothesis Testing '

'
Hypothesis tests and z-scores
A/B testing
- This uses Treatment and Control groups for testing
- It provides a way to check outcomes of competing scenarios and decide which way to proceed.
- A/B testing lets you compare scenarios to see which best achieves some goal.

Stack Overflow Developer Survey 2020
library(dplyr)
glimpse(stack_overflow)

Rows: 2,261
Columns: 8
$ respondent  <dbl> 36, 47, 69, 125, 147, 152, 166, 170, 187, 196, 221, ...
$ age_first_code_cut  <chr> 'adult', 'child', 'child', 'adult', 'adult', 'adult', ...
$ converted_comp  <dbl> 77556, 74970, 594539, 2000000, 37816, 121980, 48644...
$ job_sat  <fct> Slightly satisfied, Very satisfied, Very satisfied, ...
$ purple_link  <chr> 'Hello, old friend', 'Hello, old friend', 'Hello, o...
$ age_cat  <chr> 'At least 30', 'At least 30', 'Under 30', 'At least...
$ age  <dbl> 34, 53, 25, 41, 28, 30, 28, 26, 43, 23, 24, 35, 37, ...
$ hobbist  <chr> 'Yes', 'Yes', 'Yes', 'Yes', 'No', 'Yes', 'Yes', ...  -> out

Hypothesizing about the mean
A hypothesis:
The mean anual compensation of the population of data scientists is $110,000

The point estimate (sample statistic):
mean_comp_samp <- mean(stack_overflow$converted_comp)  

mean_comp_samp <- stack_overflow %>%
  summarize(mean_compensation = mean(converted_comp)) %>%
  pull(mean_compensation)  <- in

121915.4  -> out

Generating a bootstrap distribution
# Step 3. Repeat steps 1 & 2 many times
so_boot_distn <- replicate(
  n = 5000,
  expr = {
    # Step 1. Resample
    stack_overflow %>%
      slice_Sample(prop = 1, replace = TRUE) %>%
      # Step 2. Calculate point estimate
      summarize(mean_compensation = mean(converted_comp)) %>%
      pull(mean_compensation)
    }
)

Visualizing the bootstrap distribution
tibble(resample_mean = so_boot_distn) %>%
  ggplot(aes(resample_mean)) + geom_histogram(binwidth = 1000)

Standard error
std_error <- sd(so_boot_distn)  -> in

5344.653  -> out

Z-scores
standardized value = (value - mean) / standard deviation
#   OR
Z = (Sample Statistic - Hypothesized parameter value) / Standard Error

mean_comp_samp  -> in

121915.4  -> out

mean_comp_hyp  <- 110000

std_error  -> in

5344.653  -> out

Z_score = (mean_comp_samp - mean_comp_hyp) / std_error  

Z = ($121,915.4 - $110,000) / $5344.65  = 2.233

- The z-score is a standardized measure of the difference between the sample statistic and the hypothesized statistic.

Testing the hypothesis
Hypothsis testing use case:
Determine whether sample statistics are too close or far away from expected (or "hypothesized" values)

Standard normal ( Z ) distribution
Standard normal distribution: normal distribution with mean  0 + standard deviation = 1

tibble(x = seq(-4, 4, 0.01)) %>%
  ggplot(aes(x)) + stat_function(fun = dnorm) + ylab('PDF(x)')
'

# View the late_shipments dataset
View(late_shipments)

# Calculate the proportion of late shipments
late_prop_samp <- late_shipments %>%
  summarize(mean = mean(late == 'Yes')) %>%
  pull(mean)

# See the results
late_prop_samp


# Hypothesize that the proportion is 6%
late_prop_hyp <- 0.06

# Calculate the standard error
std_error <- late_shipments_boot_distn %>%
  summarize(sd = sd(late_prop)) %>%
  pull(sd)

# Find z-score of late_prop_samp
z_score <- (late_prop_samp - late_prop_hyp) / std_error

# See the results
z_score


'
p-values
Age of first programming experience
- age_first_code_cut classifies when Stack Overflow user first started programming
* 'adult' means they started at 14 or older
* 'child' means they started before 14
- Previous research: 35% od software developers started programming as children

- Evidence that a greater proportion of data scientists starting programming as children?

Definitions
- A hypothesis is a statement about an unknown population parameter
- A hypothesis test is a test of two competing hypotheses
* The null hypothesis (Ho) is the existing idea
* The alternative hypothesis (Ha) is the new 'challenger' idea of the researcher
For our problem:
* Ho: The proportion of data scientists starting programming as children is 35%
* Ha: The proportion of data scientists starting programming as children is greater than 35%

# "Naught" is British English for "zero". For historical reasons, "H-naught" is the international convention for pronouncing the null hypothesis.

Hypothesis Testing
- Either Ha or Ho is true (not both)
_ Initially, Ho is assumed to be true
_ The test ends in either 'reject Ho' or 'fail to reject Ho'
- If the evidence from the sample is 'significant' that Ha is true, reject Ho, else choose Ho

# Significance level is 'beyond a reasonable doubt' for hypothesis testing

One-tailed and two-tailed tests
- The tails of a distribution are the left and right edges of its PDF
- Hypothesis tests check if the sample statistics lie in the tails of the null distribution, which is the distribution of the statistic if the null hypothesis was true.
- There are 3 types of tests, and the phrasing of the alternative hypothesis determines which type we should use.
Test                                    Tails
* alternative different from null   =   2-tailed
* alternative greater than null     =   right-tailed
* alternative less than null        =   left tailed

e.g
Ha: The proportion of data scientists starting programming as children is greater than 35%
- This is a right-tailed test 

P-values
- They measure the strength of support for the null hypothesis
- p-values: probability of obtaining a result, assuming the null hypothesis is true
* Large p-value, large support for Ho
- Statistic likely not in the tail of the null distribution
* Small p-value, strong evidence against Ho
- Statistic likely in the tail of the null distribution

# "p" in p-value -> probability
"small" means "close to zero"

Calculating the z-score
prop_child_samp <- stack_overflow %>%
  summarize(point_estimate = mean(age_first_code_cut == 'child')) %>%
  pull(point_estimate)  <- in

0.388  <- out

prop_child_hyp = 0.35

std_error = 0.0096028

z_score = (prop_child_samp - prop_child_hyp) / std_error <- in

3.956  -> out

Calculating the p-value
- pnorm() is normal CDF. 
- Left-tailed test -> use default lower.tail  = TRUE
- Right-tailed test -> set lower.tail = FALSE

p_value <- pnorm(z_score, lower.tail = FALSE)  -> in

3.818e-05  -> out
'

# Calculate the z-score of late_prop_samp
z_score <- (late_prop_samp - late_prop_hyp) / std_error

# Calculate the p-value
p_value <- pnorm(z_score, lower.tail = FALSE)

# See the result
p_value   


'
Statistical significance
p-value recap
- p-values quantify evidence for the null hypothesis
- Large p-value -> fail to reject null hypothesis
- Small p-value -> reject null hypothesis

where is the cutoff point ?

Significance level
The significance level of a hypothesis test (alpha) is the threshold point for 'beyond a reasonable doubt'
- common values of alpha are 0.2, 0.1, 0.05 and 0.01
- If p <= alpha, reject Ho, else fail to reject Ho
- Alpha should be set prior to conducting the hypothesis test

Calculating the p-value
alpha <- 0.05

prop_child_samp <- stack_overflow %>%
  summarize(point_estimate = mean(age_first_code_cut == 'child')) %>%
  pull(point_estimate)

prop_child_hyp <- 0.35

std_error <- 0.0096028

z_score = (prop_child_samp - prop_child_hyp) / std error

p_value = pnorm(z_score, lower.tail = FALSE) -> in

3.818e-05 -> out

Making a decison
alpha = 0.05
print(p_value) -> in

3.818e-05 -> out

p_value <= alpha  -> in

True  -> out

# p_value is less than or equal to alpha, so Reject Ho in favour of Ha
- The proportion of data scientists starting programming as children is greater than 35%.

Confidence intervals
For a significance level of alpha, it"s common to choose a confidence interval of (1 - alpha)
- alpha = 0.05 -> 95% confidence interval
i.e
conf_int <- first_code_boot_distn %>%
  summarize(lower = quantile(first_code_child_rate, 0.025), upper = quantile(first_code_child_rate, 0.975))  -> in

# A tibble: 1 x 2
    lower   upper
    <dbl>   <dbl>
1  0.369    0.407  -> out

Types of errors
            actual Ho           actual Ha
chosen Ho   correct             false negative
chosen Ha   false positive      correct

# False positives are Type I errors; False negatives are Type II errors.

Possible errors in our example
- If p <= alpha, we reject Ho:
* A false positive (Type I) error: data scientists didn"t start coding as children at a higher rate
- If p > alpha, we fail to reject Ho:
* A false positive (Type II) error: data scientists started coding as children at a higher rate
'

# Calculate 95% confidence interval using quantile method
conf_int_quantile <- late_shipments_boot_distn %>%
  summarize(
    lower = quantile(prop_late_shipments, 0.025),
    upper = quantile(prop_late_shipments, 0.975)
)

# See the result
conf_int_quantile


' Two-Sample and ANOVA Tests '

'
Performing t-tests
Two-sample problems
- Compare sample statistics across groups of a variable
* 'converted_comp' is a numeriacal variable
* 'age_first_code_cut' is a categorical variable with levels ('child' and 'adult')

Are users who first programmed as a child compensated higher than those that started as adults?

Hypotheses
- Ho: The mean compensation (in USD) is the same for those that coded first as a child and those that coded first as an adult

Ho: Mu(child) = Mu(adult)
# OR
Ho: Mu(child) - Mu(adult) = 0

- Ha: The mean compensation (in USD) is greater for those that coded first as a child compared to those that coded first as an adult

Ho: Mu(child) > Mu(adult)
# OR
Ho: Mu(child) - Mu(adult) > 0

Calculating groupwise summary statistics
stack_overflow %>%
  group_by(age_first_code_cut) %>%
  summarize(mean_compensation = mean(converted_comp))  -> in

# A tibble: 2 x 2
    age_first_code_cut      mean_compensation
                <chr>                   <dbl>
1                adult                111544.
2                child                138275.  -> out

Test statistics
- Sample mean estimates the population mean
- x-bar is used to denote a sample mean
* x-bar(child) - sample mean compensation for coding first as a child
* x-bar(adult) - sample mean compensation for coding first as an adult
* x-bar(child) - x-bar(adult) - a test statistic
- z-score - a (standardized) test statistic

Standardizing the test statistic
z = (sample statistic - population parameter) / standard error

t = (difference in sample statistic - difference in population parameter) / standard error

t = ( ( x-bar(child) - x-bar(adult) )  - ( Mu(child) - Mu(adult) )  ) / SE( x-bar(child) - x-bar(adult) )

Standard Error
SE( x-bar(child) - x-bar(adult) ) is equal to approximate value of the square root of the (child)Standard deviation square divided by the (child)sample size + (adult)Standard deviation square divided by the (adult)sample size.

* s is the standard deviation of the variables
* n is the sample size (number of observations/rows in sample)

Assuming the null hypothesis is true
t = ( ( x-bar(child) - x-bar(adult) )  - ( Mu(child) - Mu(adult) )  ) / SE( x-bar(child) - x-bar(adult) )

Ho: Mu(child) - Mu(adult) = 0 

t = ( x-bar(child) - x-bar(adult) ) / SE( x-bar(child) - x-bar(adult) )

t = ( x-bar(child) - x-bar(adult) ) / sqrt( s^2(child) / n(child) + s^2(adult) / n(adult) )

Calculations assuming the null hypothesis is true
stack_overflow %>%
  group_by(age_first_code_cut) %>%
  summarize( xbar = mean(converted_comp), s = sd(converted_comp), n = n() )  -> in

# A tibble: 2 x 4
age_first_code_cut      xbar        s       n
            <chr>      <dbl>    <dbl>   <dbl>
adult                111544.  270381.    1579
child                138275.  278130.    1001  -> out

Calculating the test statistic
numerator <- xbar_child - xbar_adult

denominator <- sqrt(s_child ^ 2 / n_child + s_adult ^ 2 / n_adult)

t_stat <- numerator / denominator  -> in

2.4046  -> out
'

# Calculate the numerator of the test statistic
numerator <- xbar_no - xbar_yes

# Calculate the denominator of the test statistic
denominator <- sqrt(s_no ^ 2 / n_no + s_yes ^ 2 / n_yes)

# Calculate the test statistic
t_stat <- numerator / denominator

# See the result
t_stat


'
Calculating p-values from t-statistics
t-distribution
- The test statistic follow a t-distribution
- t-distributions have a parameter named degrees of freedom, or df
- t-distributions look like normal distributions, with fatter tails

Degrees of freedom
- Larger degrees of freedom -> t-distribution gets closer to the normal distribution
- Normal distribution -> t-distribution with infinite df
- Degrees of freedom: maximum number of logically independent values in the data sample.

Calculating degrees of freedom
e.g
Dataset has 5 independent observations
- four of the values are 2, 6, 8, and 5
- The sample mean is 5
- The last value must be 4
- i.e Here, there are 4 degrees of freedom

* df = n(child) + n(adult) - 2 

Significance level
alpha = 0.1

if p <= alpha, then reject Ho.

Calculating p-values: one proportion vs. a value
p_value <- pnorm(z_score, lower.tail = FALSE)

- z-statistic: needed when using one sample statistic to estimate a population parameter
- t-statistic: needed when using multiple sample statistics to estimate a population parameter

Calculating p-values: two means from different groups
numerator = xbar_child - xbar_adult

denominator = sqrt(s_child ^ 2 / n_child + s_adult ^ 2 / n_adult)

t_stat = numerator / denominator <- in

2.4046 <- out

degrees_of_freedom = n_child + n_adult - 2 <- in

2578 <- out

- Test statistic standard error used an approximation (not bootstrapping).
- Use t-distribution CDF not normal CDF

p_value <- pt(t_stat, df = degrees_of_freedom,  lower.tail = FALSE)  -> in

0.008130  <- out

- Evidence that Stack Overflow data scientists who started coding as a child earn more. 

NB: Using a sample standard deviation to estimate the standard error is computationally easier than using bootstrapping. However, to correct for the approximation, you need to use a t-distribution when transforming the test statistic to get the p-value.
'

# Calculate the degrees of freedom
degrees_of_freedom <- n_no + n_yes - 2

# Calculate the p-value from the test stat
p_value <- pt(t_stat, df = degrees_of_freedom, lower.tail = TRUE)

# See the result
p_value


'
Paired t-tests
US Republican presidents dataset
state       county      repub_percent_08    repub_percent_12
Alabama    Bullock                 25.69               23.51
Alabama    Chilton                 78.49               79.78
Alabama       Clay                 73.09               72.31
Alabama    Cullman                 81.85               84.16
Alabama   Escambia                 63.89               62.46
Alabama    Fayette                 73.93               76.19
Alabama   Franklin                 68.83               69.68
...            ...                   ...                 ...
500 rows; each row represents county-level votes in a presidential election.

Hypotheses 
Question: Was the percentage of Republican candidate votes lower in 2008 than 2012?
Formula:
Ho: Mu(2008) - Mu(2012) = 0

Ha: Mu(2008) - Mu(2012) < 0

Set alpha = 0.05 significance level

Note:
* Data is paired -> each voter percentage refers to the same county
e.g want to capture voting patterns in model

From two samples to one
sample_data <- repub_votes_potus_08_12 %>%
  mutate(diff = repub_percent_08 - repub_percent_12)

ggplot(sample_data, aes(x = diff)) + geom_histogram(binwidth = 1)

Calculate sample statistics of the difference
sample_data %>%
  summarize(xbar_diff = mean(diff))  <- in

    xbar_diff
1   -2.643027  <- out

Revised hypotheses
Old hypotheses:
Ho: Mu(2008) - Mu(2012) = 0

Ha: Mu(2008) - Mu(2012) < 0

New hypotheses:
Ho: Mu(diff) = 0

Ha: Mu(diff) < 0

t = ( x-bar(diff) - Mu(diff) ) / sqrt(  S^2 (diff) / n(diff) )

df = n(diff) - 1

Calculating the p-value
n_diff <- nrow(sample_data) <- in

100 <- out

Mu(diff) =  0

s_diff <- sample_data %>%
  summarize(sd_diff = sd(diff)) %>%
  pull(sd_diff)

t_stat <- ( xbar_diff - 0 ) / sqrt( s_diff ^ 2 / n_diff ) <- in

-16.06374  <- out

degrees_of_freedom = n_diff - 1 <- in
499 <- out

p_value <- pt( t_stat, df = degrees_of_freedom ) <- in

2.084965e-47  <- out

Therefore: Reject the Ho (null hypotheses) in favour of the Ha (alternative hypotheses) that the Repulican candidates got a smaller percentage of the vote in 2008 compared to 2012.

Testing differences between two means using t.test()
t.test(
  # Vector of differences
  sample_data$diff,
  # Choose between 'two.sided', 'less', 'greater'
  alternative='less',
  # Null hypothesis population parameter
  mu = 0
)  <- in

        One Sample t-test

data: sample_data$diff
t = -16.064, df = 499, p-value < 2.2e-16
alternative hypothesis: true mean is less than 0
95 percent confidence interval:
    -Inf  -2.37189
sample estimates:
mean of x
-2.643027  -> out

t.test() with paired = TRUE
t.test(
  sample_data$repub_percent_08,
  sample_data$repub_percent_12,
  alternative='less',
  mu = 0,
  paired = TRUE
)  <- in

        Paired t-test

data:   sample_data$repub_percent_08 and
        sample_data$repub_percent_12
t = -16.064, df = 499, p-value < 2.2e-16
alternative hypothesis: true difference in mean is less than 0
95 percent confidence interval:
    -Inf  -2.37189
sample estimates:
mean of the differences
            -2.643027  -> out

Unpaired t.test()
t.test(
  sample_data$repub_percent_08,
  sample_data$repub_percent_12,
  alternative='less',
  mu = 0
)  <- in

        Welch Two Sample t-test

data:   sample_data$repub_percent_08 and
        sample_data$repub_percent_12
t = -2.8788, df = 992.76, p-value = 0.002039
alternative hypothesis: true difference in mean is less than 0
95 percent confidence interval:
    -Inf  -1.131469
sample estimates:
mean of x mean of y
    56.52034  59.16337  -> out

Note: Unpaired t-tests on paired data increases the chances of false negative errors
'

# View the dem_votes_potus_12_16 dataset
View(dem_votes_potus_12_16)

# Calculate the differences from 2012 to 2016
sample_dem_data <- dem_votes_potus_12_16 %>%
  mutate(diff = dem_percent_12 - dem_percent_16)

# See the result
sample_dem_data

# Find mean and standard deviation of differences
diff_stats <- sample_dem_data %>%
  summarize(xbar_diff = mean(diff), s_diff = sd(diff))

# See the result
diff_stats

# Using sample_dem_data, plot diff as a histogram
ggplot(sample_dem_data, aes(diff)) + geom_histogram(binwidth = 1)


# Conduct a t-test on diff
test_results <- t.test(sample_dem_data$diff, 
  alternative = 'greater', 
  mu = 0
)

# See the results
test_results

# Conduct a paired t-test on dem_percent_12 and dem_percent_16
test_results <- t.test(sample_dem_data$dem_percent_12, 
  sample_dem_data$dem_percent_16, 
  alternative = 'greater', 
  mu = 0, 
  paired = TRUE
)

# See the results
test_results

# The Unpaired t-test
t.test(
  x = sample_dem_data$dem_percent_12,
  y = sample_dem_data$dem_percent_16,
  alternative = "greater",
  mu = 0
)


'
ANOVA tests
- This extends t-tests to more than 2 groups

Job satisfaction: 5 categories
stack_overflow %>%
  count(job_sat)  <- in

# A tibble: 5 x 2
                job_sat         n
                    <fct>   <int>
1  Very dissatisfied          187
2  Slightly dissatisfied      385
3  Neither                    245   
4  Slightly satisfied         777
5  Very satisfied             981  <- out

Visualizing multiple distributions
Is mean annual compensation different for different levels of job satisfaction ?

stack_overflow %>%
  ggplot(aes(x = job_sat, y =converted_comp )) + geom_boxplot() + coord_flip()

Analysis of variance (ANOVA)
mdl_comp_vs_job_sat <- lm(converted_comp ~ job_sat, data = stack_overflow)

anova(mdl_comp_vs_job_sat)  -> in

Analysis of Variance Table

Response: converted_comp
                Df    Sum Sq    Mean Sq     F value     Pr(>F)
job_sat          4  1.09e+12   2.73e+11        3.65     0.0057  **
Residuals     2570  1,92e+14   7.47e+10

Signif. codes:  0 '***'  0.001 '**'  0.01 '*'  0.05 '.'  0.1 ' '  1  -> out

Pairwise.t.tests()
alpha = 0.2 

Pairwise.t.tests(stack_overflow$converted_comp, stack_overflow$job_sat, p.adjust.method = 'none')  <- in

    Pairwise comparisons using t  tests with pooled SD

data:  stack_overflow$converted_comp and stack_overflow$job_sat

                        Very dissatisfied   Slightly dissatisfied   Neither     Slightly satisfied
Slightly dissatisfied             0.26860                       -         -                      -
Neither                           0.79578                 0.36858         -                      -
Slightly satisfied                0.29570                 0.82931   0.41248                      -
Very satisfied                    0.34482                 0.00384   0.15939                0.00084

P value adjustment method: none  -> out

i.e
3 values are less than alpha (Significance level) of 0.2
Significant differences: 'Very satisfied' vs 'Slightly dissatisfied'; 'Vert satisfied' vs 'Neither'; 'Very satisfied' vs 'Slightly satisfied'

In this case, there are 5 groups, resulting in 10 pairs
Note: As the number of groups increases, the number of pairs - and hence the number of hypothesis tests we must perform - increases quadratically.
- The more tests we run, the higher the chance that at least one of them will give a false positive significant result.
- With a significance level of 0.2, if we run one test, the chance of a false positive result is 0.2
- With 5 groups and 10 tests, the probability of at least one false positive is around 0.7
- With 20 groups, it"s almost guaranteed that we"ll get at least one false positive.
- The solution to this is to apply an adjustment to increase the p-values, reducing the chance of getting a false positive. (one common adjustment is the Bonferroni correction).

Bonferroni correction 
Pairwise.t.tests(stack_overflow$converted_comp, stack_overflow$job_sat, p.adjust.method = 'bonferroni')  <- in

    Pairwise comparisons using t  tests with pooled SD

data:  stack_overflow$converted_comp and stack_overflow$job_sat

                        Very dissatisfied   Slightly dissatisfied   Neither  Slightly satisfied
Slightly dissatisfied              1.0000                       -         -                   -
Neither                            1.0000                  1.0000         -                   -
Slightly satisfied                 1.0000                  1.0000    1.0000                   -
Very satisfied                     1.0000                  0.0384    1.0000              0.0084

P value adjustment method: bonferroni  -> out

i.e
2 values are less than alpha (Significance level) of 0.2
Significant differences: 'Very satisfied' vs 'Slightly dissatisfied'; 'Very satisfied' vs 'Slightly satisfied'

More methods
p.adjust.methods  -> in

Method used for testing and adjustment of pvalues.
* 'none' : no correction 
* 'bonferroni' : one-step Bonferroni correction
* 'holm' : step-down method using Bonferroni adjustments [default]
* 'BH' : Benjamini / Hochberg FDR correction
* 'BY' : Benjamini / Yekutieli FDR correction
* 'hochberg'
* 'hommel'
* 'fdr' : FDR correction

Bonferroni and Holm adjustments
p_values  -> in

0.268603  0.795778  0.295702  0.344819  0.368580  0.829315  0.003840  0.412482  0.159389  0.000838  -> out

Bonferroni
pmin(1, 10 * p_values)  -> in

1.00000  1.00000  1.00000  1.00000  1.00000  1.00000  0.03840  1.00000  1.00000  0.00838  -> out

Holm (roughly)
pmin(1, 10:1 * sort(pvalues))  -> in

0.00838  0.03456  1.00000  1.00000  1.00000 1.00000  1.00000  1.00000  1.00000  0.82931  -> out
'

# Using late_shipments, group by shipment mode, and calculate the mean and std dev of pack price
late_shipments %>%
  group_by(shipment_mode) %>%
  summarize(xbar_pack_price = mean(pack_price),
  s_pack_price = sd(pack_price))

# Using late_shipments, plot pack_price vs. shipment_mode as a box plot with flipped x and y coordinates
ggplot(late_shipments, aes(x = shipment_mode, y = pack_price)) + geom_boxplot() + coord_flip()


# Run a linear regression of pack price vs. shipment mode 
mdl_pack_price_vs_shipment_mode <- lm(late_shipments$pack_price ~ late_shipments$shipment_mode)

# See the results
summary(mdl_pack_price_vs_shipment_mode)

# Perform ANOVA on the regression model
anova(mdl_pack_price_vs_shipment_mode)


# Perform pairwise t-tests on pack price, grouped by shipment mode, no p-value adjustment
test_results <- pairwise.t.test(late_shipments$pack_price, late_shipments$shipment_mode, p.adjust.method = 'none')

# See the results
test_results

# Modify the pairwise t-tests to use Bonferroni p-value adjustment
test_results <- pairwise.t.test(
  late_shipments$pack_price,
  late_shipments$shipment_mode,
  p.adjust.method = "bonferroni"
)

# See the results
test_results


' Proportion Tests '

'
One-sample proportion tests
Chapter 1 recap
- Is a claim about an unknown population proportion feasible?
* Standard error of sample statistic from bootstrap distribution
* Compute a standardized test statistic - z score
* Calculate a p-value
* Decide which hypothesis made most sense

Standardized test statistic for proportions
P: population proportion (unknown population parameter)
P-hat: sample proportion (sample statistic)
Po: hypothesized population proportion

z =  ( P-hat -  mean( P-hat ) ) / SE( P-hat ) = ( P-hat -  P ) /  SE( P-hat )

Assuming Ho is true, P = Po, so
z = ( P-hat -  Po ) /  SE( P-hat )

Simplifying the standard error calculations
SE( P-hat ) = sqrt ( ( Po x ( 1 - Po ) ) / n ) -> Under Ho, SE( P-hat ) depends on hypothesized ( Po ) and sample size ( n )

Assuming Ho is true,

z = ( P-hat - Po ) / square root ( ( Po x ( 1 - Po ) ) / n )
* Only uses sample information ( P-hat and n ) and the hypothesized parameter ( Po )

Why Z instead of t?
e.g
t = ( X-bar(child) - X-bar(adult) ) / sqrt ( ( S ^2(child) / n(child) ) + ( S ^2(adult) / n(adult) ) )

- S is calculated from X-bar
* X-bar estimates the population mean
* S estimates the population standard deviation
* Increased uncertainty in our estimate of the parameter
- t-distribution - fatter tails than a normal distribution
- P-hat only appears in the numerator, so z-scores are fine

Stack Overflow age categories
Ho: Proportion of Stack Overflow users under thirty = 0.5

Ha: Proportion of Stack Overflow users under thirty /= (not equal) 0.5
e.g
alpha <- 0.01

stack_overflow %>%
  count(age_cat)  <- in

# A tibble: 2 x 2
    age_cat            n
    <chr>          <int>
1  At least 30      1050
2  Under 30         1216  <- out

Variables for z
p_hat <- stack_overflow %>%
  summarize(prop_under_30 = mean(age_cat == 'under 30'))  <- in

0.5366  <- out

p_0 = 0.50

n = nrow(stack_overflow)  <- in

2266  <- out

Calculatig the z-score
numerator =  p_hat - p_0

denominator = sqrt(p_0 * ( 1 - p_0) / n)

z_score = numerator / denominator  <- in

3.487  <- out

Calculating the p-value
Left-tailed ('less than'):
p_value <- pnorm(z_score)

Right-tailed ('greater than'):
p_value <- pnorm(z_score, lower.tail = FALSE)

Two-tailed ('not equal'):
p_value <- pnorm(z_score) + pnorm(z_score, lower.tail = FALSE)

p_value = 2 * pnorm(z_score)  <- in

0.000244  <- out

p_value <= alpha  <- in

True  <- out
i.e
Here, the p-value is less than the significance level of 0.01, so we reject the null hypothesis, concluding that the proportion of users under 30 is not equal to 0.5
'

# Hypothesize that the proportion of late shipments is 6%
p_0 <- 0.06

# Calculate the sample proportion of late shipments
p_hat <- late_shipments %>%
  summarize(prop_late = mean(late == 'Yes')) %>%
  pull(prop_late)

# Calculate the sample size
n <- nrow(late_shipments)

# Calculate the numerator of the test statistic
numerator <- p_hat - p_0

# Calculate the denominator of the test statistic
denominator <- sqrt( p_0 * (1 - p_0) / n)

# Calculate the test statistic
z_score <- numerator / denominator

# See the result
z_score

# Calculate the p-value from the z-score
p_value <- pnorm(z_score, lower.tail = FALSE)

# See the result
p_value


'
Two-sample proportion tests
Comparing 2 proportions
Ho: Proportion of hobbyist users is the same for those under thirty as those at least thirty
Ho: P (>= 30) - P (< 30) = 0

Ha: Proportion of hobbyist users is different for those under thirty to those at least thirty
Ha: P (>= 30) - P (< 30)  !=  0

alpha <- 0.05

Calculating the z-score
* Z-score equation for a proportion test:

z = ( ( P-hat (>= 30) - P-hat (< 30) ) - 0 (p_0) ) / SE( P-hat (>= 30) - P-hat (< 30) )

* Standard error equation:
SE( P-hat (>= 30) - P-hat (< 30) ) = square root ( ( ( P-hat x (1 - P-hat) ) / n (>= 30) ) + ( ( P-hat x (1 - P-hat) ) / n (< 30) ) )

* P-hat is a pooled estimate for p (common unknown proportion of successes).
* P-hat -> weighted mean of P-hat (>= 30) and P-hat (< 30)

P-hat = ( n (>= 30) x P-hat (>= 30) + n (< 30) x P-hat (< 30) ) / ( n (>= 30) + n (< 30) )

* We only require P-hat (>= 30), P-hat (< 30), n (>= 30), N (< 30) from the sample to calculate the z-score

Getting the numbers for the z-score
stack_overflow %>%
  group_by(age_cat) %>%
  summarize( p_hat = mean(hobbyist == 'Yes'),
  n = n()
)  <- in

# A tibble: 2 x 3
    age_cat         p_hat      n
    <chr>           <dbl>  <int>
1   At least 30     0.773   1050
2   Under 30        0.843   1216  <- out

z_score  -> in

-4.217  -> out

Proportion tests using proportions_ztest()
library(infer)

stack_overflow %>%
  prop_test(
    hobbyist ~ age_cat,                         # proportions ~ categories
    order = c('At least 30', 'Under 30'),       # which p-hat to subtract
    success = 'Yes',                            # which response value to count proportions of
    alternative = 'two-sided',                  # type of alternative hypothesis
    correct = FALSE                             # should Yates" contiuity correction be applied? 
)  -> in

# A tibble: 1 x 6
    statistic   chisq_df      p_value   alternative   lower_ci  upper_ci
        <dbl>      <dbl>        <dbl>         <chr>      <dbl>     <dbl>
1        17.8          1    0.0000248     two.sided     0.0605     0.165  -> out

i.e
The p-value is smaller than the 0.5 significance level we specified, so we can conclude that there is a difference in the proportion of hobbyists between the two age groups.
'

# See the sample variables
print(p_hats)
print(ns)

# Calculate the pooled estimate of the population proportion
p_hat <- weighted.mean(p_hats, ns)

# See the result
p_hat

# Calculate sample prop'n times one minus sample prop'n
p_hat_times_not_p_hat <- p_hat * (1 - p_hat)

# Divide this by the sample sizes
p_hat_times_not_p_hat_over_ns <- p_hat_times_not_p_hat / ns

# Calculate std. error
std_error <- sqrt(x = sum(p_hat_times_not_p_hat_over_ns))

# See the result
std_error

# Calculate the z-score
z_score <- (p_hats["expensive"] - p_hats["reasonable"]) / std_error

# See the result
z_score

# Calculate the p-value from the z-score
p_value <- pnorm(z_score, lower.tail = FALSE)

# See the result
p_value


# Perform a proportion test appropriate to the hypotheses 
test_results <- late_shipments %>%
  prop_test(
    late ~ freight_cost_group,    
    order = c('expensive', 'reasonable'),
    success = 'Yes',
    alternative = 'greater',
    correct = FALSE    
)

# See the results
test_results


'
Chi-square test of independence
- This extends proportion tests to more than 2 groups.

Independence of variables
Previous hypothesis test result: there is evidence that 'hobbyist' and 'age_cat' are associated

Statistical independence - If the proportion of successes in the response variable is the same across all categories of the explanatory variable, the two variables are statistically independent.

Job satisfaction and age category
stack_overflow %>%
  count(age_cat)  <- in

# A tibble: 2 x 2
    age_cat            n
    <chr>          <int>
1  At least 30      1050
2  Under 30         1211  <- out

stack_overflow %>%
  count(job_sat)  <- in

                job_sat         n
                    <fct>   <int>
1  Very dissatisfied          159
2  Slightly dissatisfied      342
3  Neither                    201
4  Slightly satisfied         680
5  Very satisfied             879  <- out

Declaring the hypotheses
Ho: Age categories are independent of job satisfaction levels

Ha: Age categories are not independent of job satisfaction levels

alpha <- 0.1

* Test statistic donoted X^2
* Assuming independence, how far away are the observed results from the expected values?

Exploratory visualization: proportional stacked bar plot
ggplot(stack_overflow, aes(job_sat, fill = age_cat)) + geom_bar(position = 'fill') + ylab('proportion')

Chi-square independence test using chisq_test()
library(infer)

stack_overflow %>%
  chisq_test(age_cat ~ job_sat)  <- in

# A tibble: 1 x 3
    statistic   chisq_df    p_value
        <dbl>      <int>      <dbl>
1        5.55          4      0.235  -> out

Degress of freedom:
( No. of response categories - 1 ) x ( No. of explanatory categories - 1 ) 

( 2 - 1 ) * ( 5 - 1 ) = 4

NB: P-value is 0.235, which is above the significance level we set, so we conclude that age categories are independent of job satisfaction

Swapping the variables?
ggplot(stack_overflow, aes(age_cat, fill = job_sat)) + geom_bar(position = 'fill') + ylab('proportion')

Chi-square both ways
library(infer)

stack_overflow %>%
  chisq_test(job_sat ~ age_cat)  <- in

# A tibble: 1 x 3
    statistic   chisq_df    p_value
        <dbl>      <int>      <dbl>
1        5.55          4      0.235  -> out

Ask: Are the variables X and Y independent?
Not: Is variable X independent from variable Y?
Since the order doesn"t matter

What about direction and tails?
args(chisq_test)  -> in

function (x, formula, response = NULL, explanatory = NULL, ...)  -> out

* Observed and expected counts squared must be non-negative
* chi-square (X^2)  tests are almost always right-tailed
'

# Plot vendor_inco_term filled by freight_cost_group.
# Make it a proportional stacked bar plot.
ggplot(late_shipments, aes(vendor_inco_term, fill = freight_cost_group)) + geom_bar(position = 'fill')

# Perform a chi-square test of independence on freight_cost_group and vendor_inco_term
test_results <- late_shipments %>% 
  chisq_test(freight_cost_group ~ vendor_inco_term)

# See the results
test_results


'
Chi-square goodness of fit tests
This is another variant of the chi-square test used to compare a single categorical variable to a hypothesized distribution.

Purple links
You search for a coding solution online and the first link is purple because you already visited it. How do you feel?

purple_link_counts <- stack_overflow %>%
  count(purple_link)  <- in

# A tibble: 4 x 2
          purple_link           n
    <fct>    <int>
1  Hello, old friend        1330
2  Amused                    409
3  Indifferent               426
4  Annoyed                   290  <- out

Declaring the hypotheses
hypothesized <- tribble(
  ~ purple_link, ~ prop,
  'Hello, old friend',  1 / 2,
  'Amused',             1 / 6
  'Indifferent',        1 / 6
  'Annoyed',            1 / 6
)  <- in

# A tibble: 4 x 2
    purple_link              prop
    <chr>                   <dbl>
1  Hello, old friend        0.5
2  Amused                   0.167
3  Indifferent              0.167
4  Annoyed                  0.167  <- out

Ho: The sample matches with the hypothesized distribution

Ha: The sample does not match with the hypothesized distribution

The test statistic, X^2 measures how far observed results are from expectations in each group

alpha <- 0.01

Hypothesized counts by category
n_total <- nrow(stack_overflow)

hypothesized <- tribble(
  ~ purple_link, ~ prop,
  'Hello, old friend',  1 / 2,
  'Amused',             1 / 6
  'Indifferent',        1 / 6
  'Annoyed',            1 / 6
) %>%
  mutate(n = prop * n_total)  <- in

# A tibble: 4 x 3
    purple_link              prop          n
    <chr>                   <dbl>      <dbl>
1  Hello, old friend        0.5        1228.
2  Amused                   0.167       409.
3  Indifferent              0.167       409.
4  Annoyed                  0.167       409.  <- out

Visualizing counts
ggplot(purple_link_counts, aes(purple_link, n)) + geom_col() + geom_point(data = hypothesized, color = 'purple')

chi-square goodness of fit test using chisq_test()
NB: The one-sample chi-square test is called a Goodness of Fit Test, as we"re testing how well our hypothesized data fits the observed data.

hypothesized_props <- c(
  'Hello, old friend', 1 / 2,
  Amused, 1 / 6
  Indifferent, 1 / 6
  Annoyed, 1 / 6
)

library(infer)

stack_overflow %>%
  chisq_test(
    response = purple_link,
    p = hypothesized_props
  )  -> in

# A tibble: 1 x 3
    statistic   chisq_df          p_value
        <dbl>      <dbl>            <dbl>
1        44.0          3    0.00000000154  -> out

Therefore, since the p-value returned by the function is much lower than the significance level of 0.01, so we conclude that the sample distribution of proportions is different from the hypothesized distribution of proportions.
'

# Using late_shipments, count the vendor incoterms
vendor_inco_term_counts <- late_shipments %>%
  count(vendor_inco_term)

# Get the number of rows in the whole sample
n_total <- nrow(late_shipments)

hypothesized <- tribble(
  ~ vendor_inco_term, ~ prop,
  "EXW", 0.75,
  "CIP", 0.05,
  "DDP", 0.1,
  "FCA", 0.1
) %>%
  # Add a column of hypothesized counts for the incoterms
  mutate(n = prop * n_total)

# See the results
hypothesized

# Using vendor_inco_term_counts, plot n vs. vendor_inco_term 
ggplot(vendor_inco_term_counts, aes(vendor_inco_term, n)) +
  # Make it a (precalculated) bar plot
  geom_col() +
  # Add points from hypothesized 
  geom_point(data = hypothesized)


hypothesized_props <- c(
  EXW = 0.75, CIP = 0.05, DDP = 0.1, FCA = 0.1
)

# Run chi-square goodness of fit test on vendor_inco_term
test_results <- late_shipments %>%
  chisq_test(
    response = vendor_inco_term,
    p = hypothesized_props
  )

# See the results
test_results


' Non-Parametric Tests '

'
Assumptions in hypothesis testing
Randomness
Assumption
- The samples are random subsets of larger populations
Consequence
- Sample is not representative of population
How to check this
- Understand how your data was collected
- Speak to the data collector / domain expert


Independence of observations
Assumption
- Each observation (row) in the dataset is independent
Consequence
- Increased chance of false negative / positive error
How to check this
- Understand how our data was collected


Large sample size
Assumption
- The sample is big enough to mitigate uncertainty, so that the Central Limit Theorem applies
Consequence
- Wider confidence intervals
- Increased chance of false negative / positive errors
How to check this
- It depends on the test


Large sample size: t-test
One sample
- At least 30 observations in the sample
n >= 30
n: sample size

Two samples
- At least 30 observations in each sample
n(1) >= 30, n2 >= 30
n(i): sample size for group i

ANOVA
- At least 30 observations in each sample
n(i) >= 30 for all values of i

Paired samples
- At least 30 pairs observations across the samples
Number of rows in our data >= 30


Large sample size: proportion tests
One sample
- Number of successes in sample is greater than or equal to 10
n x P-hat >= 10

- Number of failures in sample is greater than or equal to 10
n x ( 1 - P-hat ) >= 10
n: sample size
P-hat: proportion of successes in sample

Two samples
- Number of successes in each sample is greater than or equal to 10
n(1) x P-hat(1) >= 10
n(2) x P-hat(2) >= 10

- Number of failures in each sample is greater than or equal to 10
n(1) x ( 1 - P-hat(1) ) >= 10
n(2) x ( 1 - P-hat(2) ) >= 10


Large sample size: chi-square tests
- The number of successes in each group is greater than or equal to 5
n(i) x P-hat(i) >= 5 for all values of i

- The number of failures in each group is greater than or equal to 5
n(i) x ( 1 - P-hat(i) ) >= 5 for all values of i
n(i): sample size for group i
P-hat(i): proportion of successes in sample group i


Sanity check
If the bootstrap distribution doesn't look normal, assumptions likely aren't valid
* Revisit data collection to check for randomness, independence, and sample size
'

# Get counts by freight_cost_group
counts <- late_shipments %>%
  count(freight_cost_group)

# See the result
counts

# Inspect whether the counts are big enough
all(counts$n >= 30)

# Get counts by late
counts <- late_shipments %>%
  count(late)

# See the result
counts

# Inspect whether the counts are big enough
all(counts$n >= 10)

# Count the values of vendor_inco_term and freight_cost_group
counts <- late_shipments %>%
  count(vendor_inco_term, freight_cost_group)

# See the result
counts

# Inspect whether the counts are big enough
all(counts$n >= 5)

# Count the values of shipment_mode
counts <- late_shipments %>%
  count(shipment_mode)

# See the result
counts

# Inspect whether the counts are big enough
all(counts$n >= 30)


'
The "There is only one test" framework
Imbalanced data
stack_overflow_imbalanced %>%
  count(hobbyist, age_cat, .drop = FALSE)  -> in

    hobbyist    age_cat            n
1   No          At least 30        0
2   No          Under 30         191
3   Yes         At least 30       15
4   Yes         Under 30        1025  -> out

- A sample is imbalanced if some groups are much bigger than others.

Hypotheses
Ho: The proportion of hobbyists under 30 is the same as the proportion of hobbyists at least 30.

Ha: The proportion of hobbyists under 30 is different from the proportion of hobbyists at least 30.

alpha <- 0.1

Proceeding with a proportion test regardless
stack_overflow_imbalanced %>%
  prop_test(
    hobbyist ~ age_cat,
    order = c('At least 30', 'Under 30'),
    success = 'Yes',
    alternative = 'two.sided',
    correct = FALSE
  )  -> in

# A tibble: 1 x 6
    statistic   chisq_df    p_value     alternative     lower_ci    upper_ci
        <dbl>      <dbl>      <dbl>           <chr>        <dbl>       <dbl>
1        2.79          1     0.0949       two.sided      0.00718      0.0217  -> out

A grammar of graphics
Plot type       base-R                  ggplot2
Scatter plot    plot(, type = 'p')      ggplot() + geom_point()
Line plot       plot(, type = 'l')      ggplot() + geom_line()
Histogram       hist()                  ggplot() + geom_histogram()
Box plot        boxplot()               ggplot() + geom_boxplot()
Bar plot        barplot()               ggplot() + geom_bar()
Pie plot        pie()                   ggplot() + geom_bar() + coord_polar()

A grammar for hypothesis tests
- Allen Downey"s 'There is only one test' framework.
- Implemented in R in the 'infer' package.
- generate() makes simulated data
* Computationally expensive
* Robust against small samples or imbalanced data

null_distn <- dataset %>%
  specify() %>%
  hypothesize() %>%
  generate() %>%
  calculate()

obs_stat <- dataset %>%
  specify() %>%
  calculate()

get_p_value(null_distn, obs_stat)

Specifying the variables of interest
specify()
specify() selects the variable(s) you want to test.

- For 2 sample tests, use 
response ~ explanatory.

- For 1 sample tests use
response ~ NULL.

stack_overflow_imbalanced %>%
  specify(hobbyist ~ age_cat, success = 'Yes') %>%
  hypothesize(null = 'independence')  -> in

Response: hobbyist (factor)
Explanatory: age_cat (factor)
# A tibble: 1,231 x 2
    hobbyist    age_cat
        <fct>     <fct>
1   Yes         At least 30
2   Yes         At least 30
3   Yes         At least 30
4   Yes         Under 30
5   Yes         At least 30
6   Yes         At least 30
7   Yes         Under 30
# ... with 1,224 more rows  -> out
'

# Specify that we are interested in late proportions across freight_cost_groups, where "Yes" denotes success
specified <- late_shipments %>%
  specify(late ~ freight_cost_group, success = 'Yes')

# See the result
specified

# Extend the pipeline to declare a null hypothesis that the variables are independent
hypothesized <- late_shipments %>% 
  specify(
    late ~ freight_cost_group, 
    success = "Yes"
  ) %>% 
  hypothesize(null = 'independence')

# See the result
hypothesized


'
Continuing the infer pipeline
Recap: hypotheses and dataset
Ho: The proportion of hobbyists under 30 is the same as the proportion of hobbists at least 30.

Ha: The proportion of hobbyists under 30 is different from the proportion of hobbyists at least 30.

alpha <- 0.1

stack_overflow_imbalanced %>%
  count(hobbyist, age_cat, .drop = FALSE)  -> in

    hobbyist    age_cat          n
1   No          At least 30      0
2   No          Under 30       191
3   Yes         At least 30     15
4   Yes         Under 30      1025  -> out

stack_overflow_imbalanced %>%
  specify(hobbyist ~ age_cat, success = 'Yes') %>%
  hypothesize(null = 'independence')  -> in

Response: hobbyist (factor)
Explanatory: age_cat (factor)
# A tibble: 1,231 x 2
    hobbyist    age_cat
        <fct>     <fct>
1   Yes         At least 30
2   Yes         At least 30
3   Yes         At least 30
4   Yes         Under 30
5   Yes         At least 30
6   Yes         At least 30
7   Yes         Under 30
# ... with 1,224 more rows  -> out

Motivating generate()
Ho: The proportion of hobbyists under 30 is the same as the proportion of hobyists at least 30.

If Ho is true, then
- In each row, the hobbyist value coud have appeared with either age category with equal probability.
- To simulate this, we can permute (shuffle) the hobbyist values while keeping the age categories fixed.

bind_cols(
  stack_overflow_imbalanced %>%
    select(hobbyist) %>%
    slice_sample(prop = 1),
  stack_overflow_imbalanced %>%
    select(age_cat)
)  -> in

# A tibble: 1,231 x 2
    hobbyist    age_cat
        <fct>     <fct>
1   Yes         At least 30
2   Yes         At least 30
3   No          At least 30
4   No          Under 30
5   Yes         At least 30
6   Yes         At least 30
7   Yes         Under 30
# ... with 1,224 more rows  -> out

generate()
generate() generates simulated data reflecting the null hypothesis.

- For 'independence' null hypotheses, set 'type' to 'permute'

- For 'point' null hypotheses, set 'type' to 'bootstrap' or 'simulate'

stack_overflow_imbalanced %>%
  specify(hobbyist ~ age_cat, success = 'Yes') %>%
  hypothesize(null = 'independence') %>%
  generate(reps = 5000, type = 'permute')  -> in

Response: hobbyist (factor)
Explanatory: age_cat (factor)
Null Hypothesis: independence
# A tibble: 6,155,000 x 3
# Groups: replicate [5,000]
    hobbyist        age_cat     replicate
        <fct>         <fct>         <int>
1   Yes         At least 30             1
2   Yes         At least 30             1
3   Yes         At least 30             1
4   Yes         Under 30                1
5   Yes         At least 30             1
6   Yes         At least 30             1
7   Yes         Under 30                1
# ... with 6,154,993 more rows  -> out

Calculate()
calculate() calculates a distribution of test statistics know as the null distribution.

null_distn <- stack_overflow_imbalnce %>%
  specify(
    hobbyist ~ age_cat,
    success = 'Yes'
  ) %>%
  hypothesize(null = 'independence') %>%
  generate(reps = 5000, type = 'permute') %>%
  calculate(
    stat = 'diff in props',
    order = c('At leaste 30', 'Under 30')
  )  -> in

# A tibble: 5,000 x 2
    replicate       stat
    <int>          <dbl>
1   1             0.0896
2   2             0.0896
3   3            -0.180
4   4             0.157
5   5             0.0896
6   6            -0.113
7   7             0.0221
# ... with 4,993 more rows  -> out

Visualizing the null distribution
visualize(null_distn)

null_distn %>% count(stat)  -> in

# A tibble: 9 x 2
    stat            n
    <dbl>       <int>
1  -0.383           2
2  -0.315          22
3  -0.248          63
4  -0.180         246
5  -0.113         641
6  -0.0454       1132
7   0.0221       1453
8   0.0896       1063
9   0.157         378  -> out

Observed statistic: specify() %>% calculate()
obs_stat <- stack_overflow_imbalanced %>%
  specify(hobbyist ~ age_cat, success = 'Yes') %>%
  # hypothesize(null = 'independence') %>%
  # generate(reps = 5000, type = 'permute') %>%
  calculate(
    stat = 'diff in props',
    order = c('At least 30', 'Under 30')
  )  -> in

# A tibble: 1 x 1
    stat
    <dbl>
1   0.157  -> out

Visualizing the null distribution vs the observed stat
visualize(null_distn) + geom_vline(aes(xintercept = stat), data = obs_stat, color = 'red')

Get the p-value
get_p_value(
   null_distn, obs_stat,
   direction = 'two sided'   # Not alternative = 'two.sided'
) -> in

# A tibble: 1 x 1
    p_value
    <dbl>
1     0.151   

# A tibble: 1 x 6
    statistics  chisq_df    p_value     alternative     lower_ci    upper_ci
        <dbl>      <dbl>      <dbl>           <chr>        <dbl>       <dbl>
1         2.79         1     0.0949      two. sided      0.00718      0.0217  -> out
'

# Extend the pipeline to generate 2000 permutations
generated <- late_shipments %>% 
  specify(
    late ~ freight_cost_group, 
    success = "Yes"
  ) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 2000, type = 'permute')

# See the result
generated

# Extend the pipeline to calculate the difference in proportions (expensive minus reasonable)
null_distn <- late_shipments %>% 
  specify(
    late ~ freight_cost_group, 
    success = "Yes"
  ) %>% 
  hypothesize(null = "independence") %>% 
  generate(reps = 2000, type = "permute") %>% 
  calculate(
    stat = 'diff in props',
    order = c('expensive', 'reasonable')
  )

# See the result
null_distn

# Visualize the null distribution
visualize(null_distn)


# Copy, paste, and modify the pipeline to get the observed statistic
obs_stat <- null_distn <- late_shipments %>% 
  specify(
    late ~ freight_cost_group, 
    success = "Yes"
  ) %>% 
  calculate(
    stat = "diff in props", 
    order = c("expensive", "reasonable")
  )

# See the result
obs_stat

# Visualize the null dist'n, adding a vertical line at the observed statistic
visualize(null_distn) + geom_vline(aes(xintercept = stat), data = obs_stat)

# See the result
p_value


'
Non-parametric ANOVA and unpaired t-tests
A non-parametric test is a hypothesis test that doesn"t assume a probability distribution for the test statistic.

There are two types of non-parametric hypothesis test:
1. Simulation-based.
2. Rank-based.

t_test()
Ho: Mu(child) - Mu(adult) = 0

Ha: Mu(child) - Mu(adult) > 0

t_test(), for comparison
library(infer)

stack_overflow %>%
  t_test(
    converted_comp ~ age_first_code_cut,
    order = c('child', 'adult'),
    alternative = 'greater'
  )  -> in

# A tibble: 1 x 6
    statistic    t_df   p_value     alternative     lower_ci    upper_ci
        <dbl>   <dbl>     <dbl>           <chr>        <dbl>       <dbl>
1        2.40  20.83.   0.00814         greater        8438.         Inf  -> out

Simulation-based pipeline
null_distn <- stack_overflow %>%
  specify(converted_comp ~ age_first_code_cut) %>%
  hypothesize(null = 'independence') %>%
  generate(reps = 5000, type = 'permute') %>%
  calculate(
    stat = 'diff in means',
    order = c('child', 'adult')
  )  

obs_stat <- stack_overflow %>%
  specify(converted_comp ~ age_first_code_cut) %>%
  calculate(
    stat = 'diff in means',
    order = c('child', 'adult')
  )

get_p_value(
  null_distn, obs_stat,
  direction = 'greater'
)  -> in

# A tibble: 1 x 1
    stat
    <dbl>
1   0.0066  -> out

Ranks of vectors
x <- c(1, 15, 3, 10, 6)
rank(x)  -> in

1 5 2 4 3  -> out

A Wilcoxon-Mann-Whitney test (a.k.a. Wilcoxon rank sum test) is (very roughly) a t-test on the ranks of the numeric input.
- Works on unpaired data

Wilcoxon-Mann-Whitney test
wilcox.test(
  converted_comp ~ age_first_code_cut,
  data = stack_overflow,
  alternative = 'greater',
  correct = FALSE
)  -> in

                Wilcoxon rank sum test

data: converted_comp by age_first_code_cut
W = 967298,  p-value <2e-16
alternative hypothesis: true location shift is greater than 0  -> out

Kruskal-Wallis test
Kruskal-Wallis test is to Wilcoxon-Mann-Whitney test as ANOVA is to t-test.
i.e its used to extend test for more than 2 pair groups and a non-parametric version of ANOVA.

kruskal.test(
  converted_comp ~ job_sat,
  data = stack_overflow,
)  -> in

        Kruskal-Wallis rank sum test

data: converted_comp by job_sat
Kruskal-Wallis chi-square = 81, df = 4, p-value <2e-16  -> out
'

# Fill out the null distribution pipeline
null_distn <- late_shipments %>% 
  # Specify weight_kilograms vs. late
  specify(weight_kilograms ~ late) %>% 
  # Declare a null hypothesis of independence
  hypothesize(null = 'independence') %>% 
  # Generate 1000 permutation replicates
  generate(reps = 1000, type = 'permute') %>% 
  # Calculate the difference in means ("No" minus "Yes")
  calculate(
    stat = 'diff in means',
    order = c('No', 'Yes')
  )

# See the results
null_distn

# Calculate the observed difference in means
obs_stat <- late_shipments %>% 
  specify(weight_kilograms ~ late) %>% 
  calculate(
    stat = "diff in means", 
    order = c("No", "Yes")
  )

# See the result
obs_stat

# Get the p-value
p_value <- get_p_value(
  null_distn, obs_stat,
  direction = 'less'
)

# See the result
p_value


# Run a Wilcoxon-Mann-Whitney test on weight_kilograms vs. late
test_results <- wilcox.test(
  weight_kilograms ~ late,
  data = late_shipments,
)

# See the result
test_results

# Run a Kruskal-Wallace test on weight_kilograms vs. shipment_mode
test_results <- kruskal.test(
  weight_kilograms ~ shipment_mode,
  data = late_shipments,
)

# See the result
test_results