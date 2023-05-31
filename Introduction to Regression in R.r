' Simple Linear Regression '

'
A tale of two variables
Swedish motor insurance data
- Each row represents one geographic region in sweden
- There are 63 rows

n_claims    total_payment_sek
108                     392.5
19                       46.2
13                       15.7
124                     422.2
40                      119.4
...                       ...

Descriptive statistics
library(dplyr)

swedish_motor_insurance %>%
  summarize_all(mean) -> in

# A tibble: 1 x 2
    n_claims    total_payment_sek
        <dbl>               <dbl>
1        22.9                98.2  -> out

swedish_motor_insurance %>%
  summarize(correlation = cor(n_claims, total_payment_sek)) -> in

# A tibble: 1 x 1
    correlation
            <dbl>  
1           0.881   -> out

What is regression?
- Statistical models to explore the relationship between a response variable and some explanatory variables.
- Given values of explanatory variables, you can predict the values of the response variable.

n_claims    total_payment_sek
108                     392.5
19                       46.2
13                       15.7
124                     422.2
40                      119.4
200                       ???

Jargon
Response variable (a.k.a. dependent variable)
The variable that you want to predict

Explanatory variables (a.k.a. independent variables)
The variables that explain how the response variable will change

Linear regression and logistic regression
Linear regression
- The response variable is numeric

Logistic regression
- The response variable is logical

Simple linear / logistic regression
- There is only one explanatory variable

Visualizing pairs of variables and Adding a linear trend line
library(ggplot2)

ggplot(swedish_motor_insurance, aes(n_claims, total_payment_sek)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)
'

# Add a linear trend line without a confidence ribbon
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq)) +
  geom_point(alpha = 0.5) +
  geom_smooth(method='lm', se=FALSE)


'
Fitting a linear regression
Straight lines are defined by two things
Intercept
The y value at the point when x is zero

Slope
The amount the y value increases if you increase x by one

Equation
y = intercept + slope * x

Running a model
lm(formula = response ~ explanatory, data = data)

lm(total_payment_sek ~ n_claims, data = swedish_motor_insurance)    -> in

Call:
lm(formula = total_payment_sek ~ n_claims, data = swedish_motor_insurance)

Coefficients:
(Intercept)  n_Claims
    19.994      3.414   -> out

Equation
total_payment_sek = 19.994 + 3.414 * n_claims
'

# Run a linear regression of price_twd_msq vs. n_convenience
lm(price_twd_msq ~ n_convenience, data = taiwan_real_estate)


'
Categorical explanatory variables
Fish dataset
- Each row represents one fish.
- There are 128 rows in the dataset.
- There are 4 species of fish.

species     mass_g
Bream        242.0
Perch          5.9
Pike         200.0
Roach         40.0
...            ...

Visualizing 1 numeric and 1 categorical variable
library(ggplot2)

ggplot(fish, aes(mass_g)) + geom_histogram(bins = 9) + facet_wrap(vars(species))

Summary statistics: mean mass by species
fish %>%
  group_by(species) %>%
  summarize(mean_mass_g = mean(mass_g)) -> in

# A tibble: 4 x 2
    species   mean_mass_g
    <chr>           <dbl>
1   Bream           617.8
2   Perch           382.2
3    Pike           718.7
4   Roach           152.0   -> out

Linear regression
lm(mass_g ~ species, data = fish) -> in

Call:
lm(formula = mass_g ~ species, data = fish)

Coefficients:
(Intercept)     speciesPerch    speciesPike     speciesRoach
    617.8             -235.6          100.9           -465.8    -> out

No intercept
lm(mass_g ~ species + 0, data = fish) -> in

Call:
lm(formula = mass_g ~ species + 0, data = fish)

Coefficients:
speciesBream    speciesPerch    speciesPike     speciesRoach
    617.8              382.2          718.7            152.0    -> out
'

# Using taiwan_real_estate, plot price_twd_msq
ggplot(taiwan_real_estate, aes(price_twd_msq)) +
  # Make it a histogram with 10 bins
  geom_histogram(bins = 10) +
  # Facet the plot so each house age group gets its own panel
  facet_wrap(~ house_age_years)


summary_stats <- taiwan_real_estate %>% 
  # Group by house age
  group_by(house_age_years) %>% 
  # Summarize to calculate the mean house price/area
  summarize(mean_by_group = mean(price_twd_msq))

# See the result
summary_stats


# Run a linear regression of price_twd_msq vs. house_age_years
mdl_price_vs_age <- lm(price_twd_msq ~ house_age_years, taiwan_real_estate)

# See the result
mdl_price_vs_age

# Update the model formula to remove the intercept
mdl_price_vs_age_no_intercept <- lm(
  price_twd_msq ~ house_age_years + 0, 
  data = taiwan_real_estate
)

# See the result
mdl_price_vs_age_no_intercept


' Predictions and model objects '

'
Making predictions
Te fish dataset: bream
bream <- fish %>%
  filter(species == 'Bream')

species    length_cm   mass_g
Bream           23.2       242
Bream           24.0       290
Bream           23.9       340
Bream           26.3       363
Bream           26.5       430
...  ...  ...

Plotting mass vs length
ggplot(bream, aes(length_cm, mass_g)) + geom_point() + geom_smooth(method='lm', se=FALSE)

Running the model
mdl_mass_vs_length <- lm(mass_g ~ length_cm, data = bream) -> in

Call:
lm(formula = mass_g ~ length_cm, data = bream) 

Coefficients:
(Intercept)  length_cm
-1035.35  54.55 -> out

Data on explanatory values to predict
If i set the explanatory variables to these values, what value would the response variable have?

library(dplyr)

explanatory_data <- tibble(length_cm = 20:40)

Call predict()
predict(mdl_mass_vs_length, explanatory_data) -> in

        1           2           3           4           5           6
55.65205    110.20203   164.75202   219.30200   273.85198   328.40196
        7           8           9          10          11          12
382.95194   437.50192   492.05190   546.60188   601.15186   655.70184
        13         14          15          16          17          18
710.25182   764.80181   819.35179   873.90177   928.45175   983.00173
        19          20          21
1037.55171  1092.10169  1146.65167  ->out

Predicting inside a data frame
explanatory_data <- tibble(
  explanatory_var = some_values
)
explanatory_data %>%
  mutate(
    response_var = predict(model, explanatory_data)
  )

library(dplyr)
explanatory_data <- tibble(length_cm = 20:40)

prediction_data <- explanatory_data %>%
  mutate(mass_g = predict(mdl_mass_vs_length, explanatory_data)) -> in

# A tibble: 21 x 2
    length_cm   mass_g
        <int>    <dbl>
1          20     55.7
2          21    110.2
3          22    164.8
4          23    219.3
5          24    273.9
6          25    328.4
7          26    383.0
8          27    437.5
9          28    492.1
10         29    546.6
# ... with 11 more rows     -> out

Showing predictions
ggplot(bream, aes(length_cm, mass_g)) + geom_point() + geom_smooth(method='lm', se=FALSE) + geom_point(data=prediction_data, color='blue')

Extrapolating
Extrapolating means, making predictions outside the range of observed data.

explanatory_little_bream <- tibble(length_cm = 10)
explanatory_little_bream %>%
  mutate(mass_g = predict(mdl_mass_vs_length, explanatory_little_bream)) -> in

# A tibble: 1 x 2
    length_cm   mass_g
        <dbl>    <dbl>
1          10   -490.   -> out
'

# Create a tibble with n_convenience column from zero to ten
explanatory_data <- tibble(
  n_convenience = 0:10
)

# Use mdl_price_vs_conv to predict with explanatory_data
predict(mdl_price_vs_conv, explanatory_data)

# Edit this, so predictions are stored in prediction_data
prediction_data <- explanatory_data %>%
mutate(price_twd_msq = predict(mdl_price_vs_conv, explanatory_data))

# See the result
prediction_data


# Add to the plot
ggplot(taiwan_real_estate, aes(n_convenience, price_twd_msq)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add a point layer of prediction data, colored yellow
  geom_point(data=prediction_data, color='yellow')


minus_one <- tibble(n_convenience = -1)
two_pt_five <- tibble(n_convenience = 2.5)

minus_one %>%
  mutate(price_twd_msq = predict(mdl_price_vs_conv, minus_one))

two_pt_five %>%
  mutate(price_twd_msq = predict(mdl_price_vs_conv, two_pt_five))
# The model successfully gives a prediction about cases that are impossible in real life.


'
Working with model objects
coefficients()
mdl_mass_vs_length <- lm(mass_g ~ length_cm, data = bream) -> in

Call:
lm(formula = mass_g ~ length_cm, data = bream)

Coefficients:
(Intercept)     length_cm
    -1035.35        54.55   -> out

coefficients(mdl_mass_vs_length) -> in

(Intercept)    length_cm
-1035.34757     54.54998    -> out

fitted()
fitted values: predictions on the original dataset

fitted(mdl_mass_vs_length) -> in

or equivalently

explanatory_data <- bream %>%
  select(lenth_cm)

predict(mdl_mass_vs_length, explanatory_data)

        1          2           3           4           5
230.2120    273.8520    268.3970    399.3169    410.2269
        6          7           8           9          10
426.5919    426.5919    470.2319    470.2319    519.3269
        11        12          13          14          15
513.8719    530.2369    552.0569    573.8769    568.4219
        16        17          18          19          20
568.4219    622.9719    622.9719    650.2468    655.7018
        21        22          23          24          25
672.0668    677.5218    682.9768    699.3418    704.7968
        26        27          28          29          30
699.3418    710.2518    748.4368    753.8918    792.0768
        31        32          33           34          35            
873.9018    873.9018    939.3617    1004.8217   1037.5517   -> out

residuals()
Residuals: actual response values minus predicted response values

residuals(mdl_mass_vs_length) -> in

or equivalently

bream$mass_g - fitted(mdl_mass_vs_length)

    1        2       3        4      5
11.788  16.148  71.603  -36.317 19.773
    6        7        8       9      10
23.408  73.408  -80.232 -20.232 -19.327
    11       12      13       14        15
-38.872 -30.237 -52.057 -233.877    31.578
    16      17      18       19     20
31.578  77.028  77.028  -40.247 -5.702
    21     22        23      24     25
-97.067 7.478   -62.977 -19.342 -4.797
    26     27        28     29       30
25.658  9.748   -34.437 96.108  207.923
    31      32       33      34      35            
46.098  81.098  -14.362 -29.822 -87.552     -> out

summary()
summary(mdl_mass_vs_length) -> in

Call:
lm(formula = mass_g ~ length_cm, data = bream)

Residuals:
Min        1Q Median     3Q       Max
-233.9  -35.4   -4.8    31.6    207.9

Coefficients:
            Estimate    Std. Error  t value     Pr(>|t|)
(Intercept) -1035.35        107.97    -9.59      4.6e-11  ***
length_cm      54.55          3.54    15.42      < 2e-16  ***

Signif. codes:  0 '***'  0.001 '**'  0.01 '*'  0.05 '.'  0.1 ' '  1

Residual standard error: 74.2 on 33 degrees of freedom
Multiple R-squared:  0.878,  Adjusted R-squared:  0.874
F-statistic:  238 on 1 and 33 DF, p-value:  <2e-16 -> out

summary(): call
Call:
lm(formula = mass_g ~ length_cm, data = bream)

summary(): residuals
Residuals:
Min        1Q Median     3Q       Max
-233.9  -35.4   -4.8    31.6    207.9


summary(): coefficients
Coefficients:
            Estimate    Std. Error  t value     Pr(>|t|)
(Intercept) -1035.35        107.97    -9.59      4.6e-11  ***
length_cm      54.55          3.54    15.42      < 2e-16  ***

Signif. codes:  0 '***'  0.001 '**'  0.01 '*'  0.05 '.'  0.1 ' '  1

summary(): model metrics
Residual standard error: 74.2 on 33 degrees of freedom
Multiple R-squared:  0.878,  Adjusted R-squared:  0.874
F-statistic:  238 on 1 and 33 DF, p-value:  <2e-16

tidy()
library(broom)

tidy(mdl_mass_vs_length) -> in

# A tibble: 2 x 5
        term   estimate std.error   statistic   p.value
        <chr>     <dbl>     <dbl>       <dbl>     <dbl>
1 (Intercept)   -1035.     108.         -9.59   4.58e-11
2   length_cm      54.5      3.54       15.4    1.22e-16  

augment()
augment(mdl_mass_vs_length) -> in

# A tibble: 35 x 8
    mass_g  length_cm   .fitted    .resid    .hat   .sigma  .cooksd .std.resid
    <dbl>       <dbl>     <dbl>     <dbl>   <dbl>    <dbl>    <dbl>      <dbl>
1      242       23.2      230.      11.8  0.1440     75.3  0.00247      0.172
2      290       24        274.      16.1  0.1190     75.2  0.00364      0.232
3      340       23.9      268.      71.6  0.1220     74.1  0.07380      1.030
4      363       26.3      399.     -36.3  0.0651     75.0  0.00894     -0.507
5      430       26.5      410.      19.8  0.0616     75.2  0.00248      0.275
6      450       26.8      427.      23.4  0.0566     75.2  0.00317      0.325
7      500       26.8      427.      73.4  0.0566     74.1  0.03110      1.020
8      390       27.6      470.     -80.2  0.0452     73.9  0.02910     -1.110
9      450       27.6      470.     -20.2  0.0452     75.2  0.00185     -0.279
10     500       28.5      519.     -19.3  0.0360     75.2  0.00132     -0.265
# ... with 25 more rows -> out

glance()
glance(mdl_mass_vs_length) -> in

# A tibble: 1 x 12
    r.squared   adj.rsquared   sigma    statistic     p.value      df  logLik    AIC     BIC
        <dbl>           <dbl>  <dbl>        <dbl>       <dbl>   <dbl>   <dbl>  <dbl>   <dbl>
1       0.878           0.874   74.2         238.    1.22e-16       1   -199.   405.    409.
# ... with 3 more variables: deviance <dbl>, df.residual <int>, nobs <int> -> out
'

# Get the model coefficients of mdl_price_vs_conv
coefficients(mdl_price_vs_conv)

# Get the fitted values of mdl_price_vs_conv
fitted(mdl_price_vs_conv)

# Get the residuals of mdl_price_vs_conv
residuals(mdl_price_vs_conv)

# Print a summary of mdl_price_vs_conv
summary(mdl_price_vs_conv)


# Get the coefficients of mdl_price_vs_conv
coeffs <- coefficients(mdl_price_vs_conv)

# Get the intercept
intercept <- coeffs[1]

# Get the slope
slope <- coeffs[2]

explanatory_data %>% 
  mutate(
    # Manually calculate the predictions
    price_twd_msq = intercept + slope * n_convenience
  )

# Compare to the results from predict()
predict(mdl_price_vs_conv, explanatory_data)


# Get the coefficient-level elements of the model
tidy(mdl_price_vs_conv)

# Get the observation-level elements of the model
augment(mdl_price_vs_conv)

# Get the model-level elements of the model
glance(mdl_price_vs_conv)


'
Regression to the mean
The concept
- Response value = fitted value + residual
- "The stuff you explained" + "The stuff you couldn"t explain"
- Residuals exist due to problems in the model and fundamental randomness
- Extreme cases are often due to randomness
- Regression to the mean means extreme cases don"t persist over time

Pearson"s father son dataset
- 1078 father / son pairs
- Do tall fathers have tall sons?

father_height_cm    son_height_cm
165.2                       151.8
160.7                       160.6
165.0                       160.9
167.0                       159.5
155.3                       163.3
...  ...

Scatter plot
plt_son_vs_father <- ggplot(father_son, aes(father_height_cm, son_height_cm)) + geom_point() + geom_abline(color = 'green', size = 1) + coord_fixed()

Adding a regression line
plt_son_vs_father + geom_smooth(method = 'lm', se = FALSE)

Running a regression
mdl_son_vs_father <- lm(son_height_cm ~ father_height_cm, data = father_son) -> in

Call:
lm(formula = son_height_cm ~ father_height_cm, data = father_son)

Coefficients:
(Intercept) father_height_cm
    86.072              0.514   -> out

Making predictions
really_tall_father <- tibble(father_height_cm = 190)

predict(mdl_son_vs_father, really_tall_father) -> in

183.7 -> out

really_short_father <- tibble(father_height_cm = 150)

predict(mdl_son_vs_father, really_short_father) -> in

163.2 -> out
'

# Using sp500_yearly_returns, plot return_2019 vs. return_2018
ggplot(sp500_yearly_returns, aes(return_2018, return_2019)) +
  # Make it a scatter plot
  geom_point() +
  # Add a line at y = x, colored green, size 1
  geom_abline(color = 'green', size = 1) +
  # Add a linear regression trend line, no std. error ribbon
  geom_smooth(method='lm', se=FALSE) +
  # Fix the coordinate ratio
  coord_fixed()


# Run a linear regression on return_2019 vs. return_2018 using sp500_yearly_returns
mdl_returns <- lm(
  return_2019 ~ return_2018, 
  data = sp500_yearly_returns
)

# Create a data frame with return_2018 at -1, 0, and 1 
explanatory_data <- tibble(return_2018 = c(-1, 0, 1))

# Use mdl_returns to predict with explanatory_data
predict(mdl_returns, explanatory_data)


'
Transforming variables
Perch dataset
library(dplyr)

perch <- fish %>%
  filter(species == 'Perch') -> in

species     mass_g      length_cm
Perch          5.9            7.5
Perch         32.0           12.5
Perch         40.0           13.8
Perch         51.5           15.0
Perch         70.0           15.7
...  ...  ... -> out

It"s not a linear relationship
ggplot(perch, aes(length_cm, mass_g)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

Plotting mass vs length cubed
ggplot(perch, aes(length_cm ^ 3, mass_g)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

Modeling mass vs length cubed
mdl_perch <- lm(mass_g ~ I(length_cm ^ 3), data = perch) -> in

Call:
lm(formula = mass_g ~ I(length_cm ^ 3), data = perch)

Coefficients:
    (Intercept)     I(length_cm^3)
        -0.1175             0.0168  -> out

Predicting mass vs length cubed
explanatory_data <- tibble(length_cm = seq(10, 40, 5))

prediction_data <- explanatory_data %>%
  mutate(mass_g = predict(mdl_perch, explanatory_data)) -> in

# A tibble: 7 x 2
    length_cm   mass_g
        <dbl>    <dbl>
1          10     16.7
2          15     56.6
3          20    134.
4          25    262.
5          30    453.
6          35    720.
7          40    1075.  -> out

Plotting mass vs length cubed
ggplot(perch, aes(length_cm ^ 3, mass_g)) + geom_point() + geom_smooth(method = 'lm', se = FALSE) + geom_point(data = prediction_data, color = 'blue')

Facebook advertising dataset
How advertising works
1. Pay Facebook to shows sads.
2. People see the adds ('impressions')
3. Some people who see it, click it.

- 936 rows
- Each row represents 1 advert

spent_usd   n_impressions   n_clicks
1.43                 7350          1
1.82                17861          2
1.25                 4259          1
1.29                 4133          1
4.77                15615          3
... ... ...

Plot is cramped
ggplot(ad_conversion, aes(spent_usd, n_impressions)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

Square root vs square root
ggplot(ad_conversion, aes(sqrt(spent_usd), sqrt(n_impressions))) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

Modeling and predicting
- The I() function in the model formula is only needed for exponentiation.
- Undoing the transformation of the response is called backtransformation.

mdl_ad <- lm(sqrt(n_impressions) ~ sqrt(spent_usd), data = ad_conversion)

explanatory_data <- tibble( spent_usd = seq(0, 600, 100)) 

prediction_data <- explanatory_data %>%
  mutate(sqrt_n_impressions = predict(mdl_ad, explanatory_data), n_impressions = sqrt_n_impressions ^ 2) -> in

# A tibble: 7 x 3
    spent_usd   sqrt_n_impressions      n_impressions
        <dbl>                <dbl>              <dbl>
1           0                 15.3               235.
2         100                598.             357289.
3         200                839.             703890.
4         300               1024.            1048771.
5         400               1180.            1392762.
6         500               1318.            1736184.
7         600               1442.            2079202.  -> out
'

# Run the code to see the plot
# Edit so x-axis is square root of dist_to_mrt_m
ggplot(taiwan_real_estate, aes(sqrt(dist_to_mrt_m), price_twd_msq)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Run a linear regression of price_twd_msq vs. square root of dist_to_mrt_m using taiwan_real_estate

mdl_price_vs_dist <- lm(
  price_twd_msq ~ sqrt(dist_to_mrt_m), 
  data = taiwan_real_estate
)

explanatory_data <- tibble(
  dist_to_mrt_m = seq(0, 80, 10) ^ 2
)

prediction_data <- explanatory_data %>% 
  mutate(
    price_twd_msq = predict(mdl_price_vs_dist, explanatory_data)
  )

ggplot(taiwan_real_estate, aes(sqrt(dist_to_mrt_m), price_twd_msq)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add points from prediction_data, colored green, size 5
  geom_point(data = prediction_data, color = 'green', size = 5)


# Run the code to see the plot
# Edit to raise x, y aesthetics to power 0.25
ggplot(ad_conversion, aes(n_impressions ^ 0.25, n_clicks ^ 0.25)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)

# Run a linear regression of n_clicks to the power 0.25 vs. n_impressions to the power 0.25 using ad_conversion
mdl_click_vs_impression <- lm(
  I(n_clicks ^ 0.25) ~ I(n_impressions ^ 0.25),
  data = ad_conversion
)

explanatory_data <- tibble(
  n_impressions = seq(0, 3e6, 5e5)
)

prediction_data <- explanatory_data %>% 
  mutate(
    # Use mdl_click_vs_impression to predict n_clicks ^ 0.25
    n_clicks_025 = predict(mdl_click_vs_impression, explanatory_data),
    # Back transform to get n_clicks
    n_clicks = n_clicks_025 ^ 4
  )

ggplot(ad_conversion, aes(n_impressions ^ 0.25, n_clicks ^ 0.25)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE) +
  # Add points from prediction_data, colored green
  geom_point(data = prediction_data, color = 'green')


' Assessing model fit '

'
Quantifying model fit
Coefficient of determination
Sometimes called 'r-squared' or 'R-squared'.
- It is the proportion of the variance in the response variable that is predictable from the explanatory variable
* 1 means a perfect fit
* 0 means the worst possible fit

summary()
Look at the value titled 'Multiple R-squared'

mdl_bream <- lm(mass_g ~ length_cm, data = bream)

summary(mdl_bream) -> in

# Some lines of output omitted

Residual standard error: 74.15 on 33 degrees of freedom
Multiple R-squared: 0.8781, Adjusted R-squared: 0.8744
F-statistic: 237.6 on 1 and 33 DF, p-value: < 2.2e-16   -> out

glance()
library(broom)
library(dplyr)

mdl_bream %>%
  glance() -> in

# A tibble: 1 x 12
    r.squared   adj.r.squared   sigma   statistic   p.value     df  logLik    AIC    BIC
        <dbl>           <dbl>   <dbl>       <dbl>     <dbl>  <dbl>   <dbl>  <dbl>  <dbl>
1       0.878           0.874    74.2        238.  1.22e-16      1   -199.   405.   409.
#  ...  with 3 more variables: deviance  <dbl>, df.residual  <int>, nobs  <int>  -> out

mdl_bream %>%
  glance() %>%
  pull(r.squared)   -> in

0.8780627   -> out

It"s just correlation squared
bream %>%
  summarize(coeff_determination = cor(length_cm, mass_g) ^ 2)   -> in

    coeff_determination
1             0.8780627     -> out

Residual standard error (RSE)
a 'typical' difference between a prediction and an observed response
- It has the same unit as the response variable.

summary() again
Look at the value titiled 'Residual standard error'

summary(mdl_bream)  -> in

# Some lines of output omitted

Residual standard error: 74.15 on 33 degrees of freedom
Multiple R-squared: 0.8781, Adjusted R-squared: 0.8744
F-statistic: 237.6 on 1 and 33 DF, p-value: < 2.2e-16   -> out
 
glance() again
library(broom)
library(dplyr)

mdl_bream %>%
  glance()  -> in

# A tibble: 1 x 11
    r.squared   adj.r.squared   sigma   statistic   p.value     df  logLik    AIC    BIC    deviance    df.residual
        <dbl>           <dbl>   <dbl>       <dbl>     <dbl>  <dbl>   <dbl>  <dbl>  <dbl>       <dbl>          <int>
1       0.878           0.874    74.2        238.  1.22e-16      1   -199.   405.   409.     181452.             33     -> out

mdl_bream %>%
  glance() %>%
  pull(sigma)   -> in

74.15224    -> out

Calculating RSE: residuals squared
bream %>%
  mutate(residuals_sq = residuals(mdl_bream) ^ 2)   -> in

    species     mass_g      length_cm   residuals_sq
1     Bream        242           23.2       138.9571
2     Bream        290           24.0       260.7586
3     Bream        340           23.9      5126.9926
4     Bream        363           26.3      1318.9197
5     Bream        430           26.5       390.9743
6     Bream        450           26.8       547.9380
...     -> out

Calculating RSE: sum of residuals squared
bream %>%
  mutate(residuals_sq = residuals(mdl_bream) ^ 2) %>%
  summarize(resid_sum_of_sq = sum(residuals_sq))    -> in

    resid_sum_of_sq
1          181452.3     -> out

Calculating RSE: degrees of freedom
Degrees of freedom equals the number of observations minus the number of model coefficients.

bream %>%
  mutate(residuals_sq = residuals(mdl_bream) ^ 2) %>%
  summarize(resid_sum_of_sq = sum(residuals_sq), deg_freedom = n() - 2)     -> in

    resid_sum_of_sq     deg_freedom
1          181452.3              33     -> out

Calculating RSE: square root of ratio
bream %>%
  mutate(residuals_sq = residuals(mdl_bream) ^ 2) %>%
  summarize(resid_sum_of_sq = sum(residuals_sq), deg_freedom = n() - 2, rse = sqrt(resid_sum_of_sq / deg_freedom))  -> in

    resid_sum_of_sq     deg_freedom          rse
1          181452.3              33     74.15224  -> out

Interpreting RSE
mdl_bream has an RSE of 74.
- The difference between predicted bream masses and observed bream masses is typically about 74g.

Root-mean-square error (RMSE)
bream %>%
  mutate(residuals_sq = residuals(mdl_bream) ^ 2) %>%
  summarize(resid_sum_of_sq = sum(residuals_sq), n_obs = n(), rmse = sqrt(resid_sum_of_sq / n_obs)) 
'

# Print a summary of mdl_click_vs_impression_orig
summary(mdl_click_vs_impression_orig)

# Print a summary of mdl_click_vs_impression_trans
summary(mdl_click_vs_impression_trans)

# Get coeff of determination for mdl_click_vs_impression_orig
mdl_click_vs_impression_orig %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out r.squared
  pull(r.squared)

# Do the same for the transformed model
mdl_click_vs_impression_trans %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out r.squared
  pull(r.squared)


# Get RSE for mdl_click_vs_impression_orig
mdl_click_vs_impression_orig %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out sigma
  pull(sigma)

# Do the same for the transformed model
mdl_click_vs_impression_trans %>% 
  # Get the model-level details
  glance() %>% 
  # Pull out sigma
  pull(sigma)


'
Visualizing model fit
Hoped for properties of residuals
- Residuals are normally distributed
- The mean of the residuals is zero

* Residuals vs fitted values (x-axis=Fitted values, y-axis=Residuals)
* Q-Q plot (x-axis=Theoretical Quantiles, y-axis=Standardized residuals(i.e Residuals / std Deviation))
* Scale-location (x-axis=Fitted values, y-axis=sqrt of Standardized residuals)

autoplot()
library(ggplot2)
library(ggfortify)

autoplot(model_object, which = ???)

Values for which
-   1     residuals vs. fitted values
-   2     Q-Q plot
-   3     scale-location

autoplot() with the perch model
autoplot(mdl_perch, which = 1:3, nrow = 3, ncol = 1)
'

# Plot the three diagnostics for mdl_price_vs_conv
autoplot(mdl_price_vs_conv, which = 1:3, nrow = 3, ncol = 1)


'
Outliers, leverage, and influence
Roach dataset
roach <- fish %>%
  filter(species == 'Roach')

species     length_cm   mass_g
Roach            12.9       40
Roach            16.5       69
Roach            17.5       78
Roach            18.2       87
Roach            18.6      120
...               ...      ...

Which points are outliers?
* The technical term for an unusual data point is an outlier

ggplot(roach, aes(length_cm, mass_g)) + geom_point() + geom_smooth(method = 'lm', se = FALSE)

Extreme explanatory values
roach %>%
  mutate(has_extreme_length = length_cm < 15 | length_cm > 26) %>%
  ggplot(aes(length_cm, mass_g)) + geom_point(aes(color = has_extreme_length)) + geom_smooth(method = 'lm', se = FALSE)

Response values away from the regression line
roach %>%
  mutate(has_extreme_length = length_cm < 15 | length_cm > 26, has_extreme_mass = mass_g < 1) %>%
  ggplot(aes(length_cm, mass_g)) + geom_point(aes(color = has_extreme_length, shape = has_extreme_mass)) + geom_smooth(method = 'lm', se = FALSE)

Leverage
Leverage is a measure of how extreme the explanatory variable values are.

mdl_roach <- lm(mass_g ~ length_cm, data = roach)

hatvalues(mdl_roach)    -> in

    1        2       3       4       5       6       7
0.3137  0.1255  0.0935  0.0763  0.0684  0.0619  0.0605
    8        9      10      11      12      13      14
0.0568  0.0503  0.0501  0.0501  0.0506  0.0509  0.0581
    15      16      17      18      19      20
0.0581  0.0593  0.0884  0.0995  0.1334  0.3947  -> out

The .hat column
library(broom)
augment(mdl_roach)  -> in

# A tibble: 20 x 8
    mass_g  length_cm   .fitted     .resid    .hat   .sigma    .cooksd  .std.resid
    <dbl>       <dbl>     <dbl>      <dbl>   <dbl>    <dbl>      <dbl>       <dbl>
1       40       12.9     -28.6       68.6  0.314      33.8  1.07           2.17
2       69       16.5      55.4       13.6  0.126      39.1  0.0104         0.381
3       78       17.5      78.7     -0.711  0.0935     39.3  0.0000197     -0.0196
4       87       18.2      95.0      -8.03  0.0763     39.2  0.00198       -0.219
5      120       18.6     104.        15.6  0.0684     39.1  0.00661        0.424
...     -> out

Highly leveraged roaches
mdl_roach %>%
  augment() %>%
  select(mass_g, length_cm, leverage = .hat) %>%
  arrange(desc(leverage)) %>%
  head() -> in

# A tibble: 6 x 3
    mass_g      length_cm   leverage
    <dbl>           <dbl>      <dbl>  
1      390           29.5     0.395     # really long roach
2       40           12.9     0.314     # really short roach
3      271           25       0.133
4       69           16.5     0.126
5      290           24       0.0995
6       78           17.5     0.0935    -> out

Influence
Influence measures how much the model would change if you left the observation out of the dataset when modeling.

Cook"s distance
Cook"s distance is the most common measure of influence

cooks.distance(mdl_roach)   -> in

        1          2           3           4           5           6
1.07e+00    1.04e-02    1.97e-05    1.98e-03    6.61e-03    3.12e-01
        7          8           9          10          11          12
8.53e-04    1.99e-04    2.57e-04    2.56e-04    2.45e-03    7.95e-03
        13        14          15          16          17          18     
1.37e-04    4.82e-03    1.15e-02    4.52e-03    6.12e-02    1.50e-01
        19        20
2.06e-02    3.66e-01    -> out

The .cooksd column
library(broom)
augment(mdl_roach)  -> in

# A tibble: 20 x 8
    mass_g  length_cm  .fitted  .se.fit     .resid    .hat  .sigma      .cooksd  .std.resid
    <dbl>       <dbl>    <dbl>    <dbl>      <dbl>   <dbl>   <dbl>        <dbl>       <dbl>
1       40       12.9    -28.6     21.4     68.6    0.314     33.8    1.07           2.17
2       69       16.5     55.4     13.5     13.6    0.126     39.1    0.0104         0.381
3       78       17.5     78.7     11.7     -0.711  0.0935    39.3    0.0000197     -0.0196
4       87       18.2     95.0     10.5     -8.03   0.0763    39.2    0.00198       -0.219
5      120       18.6    104.      9.98     15.6    0.0684    39.1    0.00661        0.424
... -> out

Most influential roaches
mdl_roach %>%
  augment() %>%
  select(mass_g, length_cm, cooks_dist = .cooksd) %>%
  arrange(desc(cooks_dist)) %>%
  head() -> in

# A tibble: 6 x 3
    mass_g  length_cm  cooks_dist
    <dbl>       <dbl>       <dbl>  
1      40        12.9      1.07     # really short roach
2      390       29.5      0.366    # really long roach
3        0       19        0.312    # zero mass roach
4      290       24        0.150
5      180       23.6      0.0612
6      272       25        0.0206  -> out

Removing the most influential roach
roach_not_short <- roach %>%
  filter(length != 12.9)

ggplot(roach, aes(length_cm, mass_g)) + geom_point() +  geom_smooth(method = 'lm', se = FALSE) + geom_smooth(method = 'lm', se = FALSE, data = roach_not_short, color = 'red')

autoplot()
autoplot(mdl_roach, which = 4:6, nrow = 3, ncol = 1)

-   4   Cook"s distance (x-axis= Obs Number, y-axis= Cook"s distance)
-   5   Residuals vs Leverage (x-axis= Leverage, y-axis= Standardized Residuals)
-   6   Cook"s distance vs Leverage (x-axis= Leverage, y-axis= Cook"s distance)
'

mdl_price_vs_dist %>% 
  # Augment the model
  augment() %>% 
  # Arrange rows by descending leverage
  arrange(desc(.hat)) %>% 
  # Get the head of the dataset
  head()

mdl_price_vs_dist %>% 
  # Augment the model
  augment() %>% 
  # Arrange rows by descending Cook's distance
  arrange(desc(.cooksd)) %>% 
  # Get the head of the dataset
  head()

# Plot the three outlier diagnostics for mdl_price_vs_dist
autoplot(mdl_price_vs_dist, which = 4:6, nrow = 3, ncol = 1)


' Simple logistic regression '

'
Why you need logistic regression
Bank churn dataset
has_churned     time_since_first_purchase   time_since_last_purchase
0                               0.3993247                 -0.5158691
1                              -0.4297957                  0.6780654
0                               3.7383122                  0.4082544
0                               0.6032289                 -0.6990435
...                                   ...                        ...
response            length of relationship       recency of activity

Churn vs recency: a linear model
mdl_churn_vs_recency_lm <- lm(has_churned ~ time_since_last_purchase, data = churn)     -> in

Call:
lm(formula = has_churned ~ time_since_last_purchase, data = churn)

Coefficients:
(Intercept)     time_since_last_purchase
    0.49078                      0.06378    ->  out

coeffs <- coefficients(mdl_churn_vs_recency_lm)
intercept <- coeffs[1]
slope <- coeffs[2]

Visualizing the linear model
ggplot(churn, aes(time_since_last_purchase, has_churned)) + geom_point() + geom_abline(intercept = intercept, slope = slope)

- Predictions are probabilities of churn, not amounts of churn.

Zooming out
ggplot(churn, aes(time_since_last_purchase, has_churned)) + geom_point() + geom_abline(intercept = intercept, slope = slope) + xlim(-10, 10) + ylim(-0.2,  1.2)

What is logistic regression?
- Another type of generalized linear model.
- Used when the response variable is logical
- The reponses follow logistic (S-shaped) curve.

Linear regression using glm()
glm(has_churned ~ time_since_last_purchase, data = churn, family = gaussian)    -> in

Call:  glm(formula = has_churned ~ time_since_last_purchase, family = gaussian, data = churn)

Coefficients:
(Intercept)     time_since_last_purchase
    0.49078                      0.06378    

Degrees of Freedom: 399 Total (i.e. Null);  398 Residual
Null Deviance:  100
Residual Deviance:  98.02    AIC:   578.7  -> out

Logistic regression: glm() with binomial family
mdl_recency_glm <- glm(has_churned ~ time_since_last_purchase, data = churn, family = binomial)     -> in

Call:  glm(formula = has_churned ~ time_since_last_purchase, family = binomial, data = churn)

Coefficients:
(Intercept)     time_since_last_purchase
    -0.03502                     0.26921    ->  out

Degrees of Freedom: 399 Total (i.e. Null);  398 Residual
Null Deviance:  554.5
Residual Deviance:  546.4    AIC:   550.4  -> out

Visualizing the logistic model
ggplot(churn, aes(time_since_last_purchase, has_churned)) + geom_point() + geom_abline(intercept = intercept, slope = slope) + geom_smooth(method = 'glm', se = FALSE, method.args = list(family = binomial))
'

# Using churn, plot time_since_last_purchase
ggplot(churn, aes(time_since_last_purchase)) +
  # as a histogram with binwidth 0.25
  geom_histogram(binwidth = 0.25) +
  # faceted in a grid with has_churned on each row
  facet_grid(rows = vars(has_churned))

# Redraw the plot with time_since_first_purchase
ggplot(churn, aes(time_since_first_purchase)) + geom_histogram(binwidth = 0.25) + facet_grid(rows = vars(has_churned))


# Using churn plot has_churned vs. time_since_first_purchase
ggplot(churn, aes(time_since_first_purchase, has_churned)) +
  # Make it a scatter plot
  geom_point() +
  # Add an lm trend line, no std error ribbon, colored red
  geom_smooth(method = 'lm', se = FALSE, color = 'red')

ggplot(churn, aes(time_since_first_purchase, has_churned)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  # Add a glm trend line, no std error ribbon, binomial family
  geom_smooth(method = "glm", se = FALSE, method.args = list(family = binomial))


# Fit a logistic regression of churn vs. length of relationship using the churn dataset
mdl_churn_vs_relationship <- glm(has_churned ~ time_since_first_purchase, family = binomial, data = churn)

# See the result
mdl_churn_vs_relationship


'
Predictions and odds ratios
Making predictions
mdl_recency <- glm(has_churned ~ time_since_last_purchase, data = churn, family = 'binomial')

explanatory_data <- tibble(time_since_last_purchase = seq(-1, 6, 0.25))

prediction_data <- explanatory_data %>%
  mutate(has_churned = predict(mdl_recency, explanatory_data, type = 'response'))

Adding point predictions
plt_churn_vs_recency_base + geom_point(data = prediction_data, color = 'blue')

Getting the most likely outcome
prediction_data <- explanatory_data %>%
  mutate(
    has_churned = predict(mdl_recency, explanatory_data, type = 'response'), 
    most_likely_outcome = round(has_churned)
    )

Visualizing most likely outcome
plt_churn_vs_recency_base + geom_point(aes(y = most_likely_outcome), data = prediction_data, color = 'green')

Odds ratios
Odds ratio is the probability of something happening divided by the probability thst it doesn"t

odds_ratio = probability / (1 - probability)

odds_ratio = 0.25 / (1 - 0.25) = 1/3

Calculating odds ratio
prediction_data <- explanatory_data %>%
  mutate(
    has_churned = predict(mdl_recency, explanatory_data, type = 'response'), 
    most_likely_response = round(has_churned), 
    odds_ratio = has_churned / (1 - has_churned)
    )

Visualizing odds ratio
ggplot(prediction_data, aes(time_since_last_purchase, odds_ratio)) + geom_line() + geom_hline(yintercept = 1, linetype = 'dotted')

Visualizing log odds ratio
ggplot(prediction_data, aes(time_since_last_purchase, odds_ratio)) + geom_line() + geom_hline(yintercept = 1, linetype = 'dotted') + scale_y_log10()

Calculating log odds ratio
prediction_data <- explanatory_data %>%
  mutate(
    has_churned = predict(mdl_recency, explanatory_data, type = 'response'), 
    most_likely_response = round(has_churned), 
    odds_ratio = has_churned / (1 - has_churned), 
    log_odds_ratio = log(odds_ratio), 
    log_odds_ratio2 = predict(mdl_recency, explanatory_data)
    )

All predictions together
tm_snc_lst_prch     has_churned     most_lkly_rspns     odds_ratio      log_odds_ratio      log_odds_ratio2
0                         0.491                   0          0.966              -0.035               -0.035
2                         0.623                   1          1.654               0.503                0.503
4                         0.739                   1          2.834               1.042                1.042
6                         0.829                   1          4.856               1.580                1.580
...                         ...                 ...            ...                 ...                  ...

Comparing scales
Scale                   Are values easy to interpret?   Are changes easy to interpret?  Is precise?
Probability                                         +                                x            +
Most likely outcome                                ++                                +            x
Odds ratio                                          +                                x            +
Log odds ratio                                      x                                +            +
'

# Make a data frame of predicted probabilities
prediction_data <- explanatory_data %>% 
  mutate(   
    has_churned = predict(mdl_churn_vs_relationship, explanatory_data, type = "response")
  )

# Update the plot
plt_churn_vs_relationship +
  # Add points from prediction_data, colored yellow, size 2
  geom_point(data = prediction_data, color = 'yellow', size = 2)


# Update the data frame
prediction_data <- explanatory_data %>% 
  mutate(   
    has_churned = predict(mdl_churn_vs_relationship, explanatory_data, type = "response"),
    most_likely_outcome = round(has_churned)
  )

# Update the plot
plt_churn_vs_relationship +
  # Add most likely outcome points from prediction_data, colored yellow, size 2
  geom_point(color = 'yellow', size = 2, data = prediction_data, aes(y = most_likely_outcome))


# From previous step
prediction_data <- explanatory_data %>% 
  mutate(   
    has_churned = predict(mdl_churn_vs_relationship, explanatory_data, type = "response"),
    odds_ratio = has_churned / (1 - has_churned)
  )

# Using prediction_data, plot odds_ratio vs. time_since_first_purchase
ggplot(prediction_data, aes(time_since_first_purchase, odds_ratio)) +
  # Make it a line plot
  geom_line() +
  # Add a dotted horizontal line at y = 1
  geom_hline(yintercept = 1, linetype = 'dotted')


# Update the data frame
prediction_data <- explanatory_data %>% 
  mutate(   
    has_churned = predict(mdl_churn_vs_relationship, explanatory_data, type = "response"),
    odds_ratio = has_churned / (1 - has_churned),
    log_odds_ratio = log(odds_ratio)
  )

# Update the plot
ggplot(prediction_data, aes(time_since_first_purchase, odds_ratio)) +
  geom_line() +
  geom_hline(yintercept = 1, linetype = "dotted") +
  # Use a logarithmic y-scale
  scale_y_log10()


'
Quantifying logistic regression fit
The four outcomes
                    actual false       actual true
predicted false          correct    false negative
predicted true    false positive           correct  

Confusion matrix: counts of outcomes
mdl_recency <- glm(has_churned ~ time_since_last_purchase, data = churn, family = 'binomial')

actual_response <-  churn$has_churned

predicted_response <- round(fitted(mdl_recency))

outcomes <- table(predicted_response, actual_response)  -> in

                    actual_response
predicted_response    0       1
                0   141     111
                1    59      89     -> out

Visualizing the confusion matrix: mosaic plot
library(ggplot2)
library(yardstick)

confusion <- conf_mat(outcomes)     -> in

                    actual_response
predicted_response    0       1
                0   141     111
                1    59      89     -> out

autoplot(confusion)

Performance metrics
summary(confusion, event_level = 'second')  -> in

# A tibble: 13 x 3
                .metric     .estimator  .estimate
                    <chr>        <chr>      <dbl>
1               accuracy        binary      0.575
2                    kap        binary      0.150
3                   sens        binary      0.445
4                   spec        binary      0.705
5                    ppv        binary      0.601
6                    npv        binary      0.560
7                    mcc        binary      0.155
8                j_index        binary      0.150
9           bal_accuracy        binary      0.575
10  detection_prevalence        binary      0.37
11             precision        binary      0.601
12                recall        binary      0.445
13                f_meas        binary      0.511   -> out

Accuracy
summary(confusion) %>%
  slice(1)  -> in

# A tibble: 3 x 3
    .metric     .estimator  .estimate
        <chr>        <chr>      <dbl>
1    accuracy       binary      0.575   -> out

- Accuracy is the proportion of correct predictions.

accuracy = (TN + TP) / (TN + FN + FP + TP)

confusion   -> in

                    actual_response
predicted_response    0       1
                0   141     111
                1    59      89     -> out

(141 + 89) / (141 + 111 + 59 + 89)  -> in

0.575   -> out

Sensitivity
summary(confusion) %>%
  slice(3)  -> in

# A tibble: 3 x 3
    .metric     .estimator  .estimate
        <chr>        <chr>      <dbl>
1        sens       binary      0.445   -> out

- Sensitivity is the proportion of true positives.

sensitivity = TP / (FN + TP)

confusion   -> in

                    actual_response
predicted_response    0       1
                0   141     111
                1    59      89     -> out

89 / (111 + 89)     -> in

0.445   -> out

Specificity
summary(confusion) %>%
  slice(4)  -> in

# A tibble: 3 x 3
    .metric     .estimator  .estimate
        <chr>        <chr>      <dbl>
1        spec       binary      0.705   -> out

- Sensitivity is the proportion of true negatives.

specificity = TN / (TN + FP)

confusion   -> in

                    actual_response
predicted_response    0       1
                0   141     111
                1    59      89     -> out

141 / (141 + 59)    -> in

0.705   -> out
'

# Get the actual responses from the dataset
actual_response <- churn$has_churned

# Get the "most likely" responses from the model
predicted_response <- round(fitted(mdl_churn_vs_relationship))

# Create a table of counts
outcomes <- table(predicted_response, actual_response)

# See the result
outcomes


# Convert outcomes to a yardstick confusion matrix
confusion <- conf_mat(outcomes)

# Plot the confusion matrix
autoplot(confusion)

# Get performance metrics for the confusion matrix
summary(confusion, event_level = 'second')