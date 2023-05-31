' How to Write a Function '

'
Why you should use functions
The arguments to mean()
Mean has 3 arguments
- x : A numeric or date-time vector.
- trim : The proportion of outliers from each end to remove before calculating
- na.rm : A logical value determining whether missing values should be removed before calculating

Calling mean()
- Pass arguments by position
mean(numbers, 0.1, TRUE)

- Pass arguments by name
mean(na.rm=TRUE, trim=0.1, x=numbers)

- Common arguments by position, rare arguments by name
mean(numbers, trim=0.1, na.rm=TRUE)

Analyzing test scores
library(readr)
test_scores_geography_raw <- read_csv('test_scores_geography.csv')

library(dplyr)
library(lubridate)
test_scores_geography_clean <- test_scores_geography_raw %>%
  select(person_id, first_name, last_name, test_date, score) %>%
  mutate(test_date=mdy(test_date))
  filter(!is.na(score))

library(readr)
test_scores_english_raw <- read_csv('test_scores_english.csv')

library(dplyr)
library(lubridate)
test_scores_english_clean <- test_scores_english_raw %>%
  select(person_id, first_name, last_name, test_date, score) %>%
  mutate(test_date=mdy(test_date))
  filter(!is.na(score))

library(readr)
test_scores_art_raw <- read_csv('test_scores_art.csv')

library(dplyr)
library(lubridate)
test_scores_art_clean <- test_scores_art_raw %>%
  select(person_id, first_name, last_name, test_date, score) %>%
  mutate(test_date=mdy(test_date))
  filter(!is.na(score))

library(readr)
test_scores_spanish_raw <- read_csv('test_scores_spanish.csv')

library(dplyr)
library(lubridate)
test_scores_spanish_clean <- test_scores_spanish_raw %>%
  select(person_id, first_name, last_name, test_date, score) %>%
  mutate(test_date=mdy(test_date))
  filter(!is.na(score))

Benefits of writing functions
Functions eliminate repetition from your code, which
- can reduce your workload, and
- help avoid errors.
Functions allow code reuse and sharing.
'

# Look at the gold medals data
gold_medals

# Note the arguments to median()
args(median)

# Rewrite this function call, following best practices
median(gold_medals, na.rm=TRUE)

# Note the arguments to rank()
args(rank)

# Rewrite this function call, following best practices
rank(-gold_medals, na.last="keep", ties.method="min")


'
Converting scripts into functions
A basic function template
my_fun <- function(arg1, arg2) {
    # Do something
}

- The signature
function(arg1, arg2)

- The body
{
    # Do something
}

library(readr)
test_scores_geography_raw <- read_csv('test_scores_geography.csv')

library(dplyr)
library(lubridate)
test_scores_geography_clean <- test_scores_geography_raw %>%
  select(person_id, first_name, last_name, test_date, score) %>%
  mutate(test_date=mdy(test_date))
  filter(!is.na(score))

Writing a function
import_test_scores <- function(filename) {
    test_scores_raw <- read_csv(filename)

    test_scores_raw %>%
    select(person_id, first_name, last_name, test_date, score) %>%
    mutate(test_date=mdy(test_date))
    filter(!is.na(score))
}

Use your function
test_scores_geography <- import_test_scores('test_scores_geography.csv')
test_scores_english <- import_test_scores('test_scores_english.csv')
test_scores_art <- import_test_scores('test_scores_art.csv')
test_scores_spanish <- import_test_scores('test_scores_spanish.csv')

Arguments of sample()
- x : A vector of values to sample from
- size : How many times do you want to sample from x?
- replace : Should you sample with replacement or not?
- prob : A vector of sampling weights for each value of x, totaling one.
'

coin_sides <- c("head", "tail")

# Sample from coin_sides once
sample(coin_sides, size=1)

# Your functions, from previous steps
toss_coin <- function() {
    coin_sides <- c("head", "tail")
    sample(coin_sides, 1)
}

# Call your function
toss_coin()


coin_sides <- c("head", "tail")
n_flips <- 10

# Sample from coin_sides n_flips times with replacement
sample(coin_sides, size=n_flips, replace=TRUE)

# Update the function to return n coin tosses
toss_coin <- function(n_flips) {
    coin_sides <- c("head", "tail")
    sample(coin_sides, size=n_flips, replace=TRUE)
}

# Generate 10 coin tosses
toss_coin(10)


coin_sides <- c("head", "tail")
n_flips <- 10
p_head <- 0.8

# Define a vector of weights
weights <- c(p_head, 1 - p_head)

# Update so that heads are sampled with prob p_head
sample(coin_sides, n_flips, replace = TRUE, prob=weights)

# Update the function so heads have probability p_head
toss_coin <- function(n_flips, p_head) {
    coin_sides <- c("head", "tail")
    # Define a vector of weights
    weights <- c(p_head, 1-p_head)
    # Modify the sampling to be weighted
    sample(coin_sides, n_flips, replace = TRUE, prob=weights)
}

# Generate 10 coin tosses
toss_coin(10, 0.8)


'
Y kant I reed ur code?
dplyr verbs
- select() : selects columns
- filter() : filters rows

Function names should contain a verb
- get
- calculate (Or maybe just calc)
- run
- process
- import
- clean
- tidy
- draw

Linear model lm() is badly named
- Acronyms aren"t self-explanatory
- It doesn"t contain a verb
- There are lots of different linear models
A better name would be run_linear_regression()

Readability vs. typeability
- Understanding code >> typing code
- Code editors have autocomplete
- You can alias common functions
h <- head

data(cats, package='MASS')
h(cats) -> in

    Sex     Bwt     Hwt
1   F       2.0     7.0
2   F       2.0     7.4
3   F       2.0     9.5
4   F       2.1     7.2
5   F       2.1     7.3
6   F       2.1     7.6     -> out

Arguments of lm()
args(lm) -> in

function (formula, data, subset, weights, na.action, method='qr', model=TRUE, x=FALSE, y=FALSE, qr=TRUE, singular.o=TRUE, contrasts=NULL, offset, ...) -> out

Types of argument
- Data arguments : what you compute on
- Detail arguments : how to perform the computation

args(cor) -> in

function (x, y=NULL, use='everything', method=c('pearson', 'kendall', 'spearman')) -> out

Data args should precede detail args
This won"t work
data %>%
  lm(formula)
because the data argument isn"t first.

Our revised function for linear regression
run_linear_regression <- function(data, formula) {
    lm(formula, data)
}

cats %>%
  run_linear_regression(Hwt ~ Bwt + Sex) -> in

Call:
lm(formula=formula, data=data)

Coefficients:
(Intercept)     Bwt         SexM
-0.4150         4.0758      -0.0821
'

# Run a generalized linear regression 
glm(
  # Model no. of visits vs. gender, income, travel
  n_visits ~ gender + income + travel, 
  # Use the snake_river_visits dataset
  data = snake_river_visits, 
  # Make it a Poisson regression
  family = 'poisson'
)

# Write a function to run a Poisson regression
run_poisson_regression <- function(data, formula) {
    glm(formula=formula, data=data, family = 'poisson')   
}

# From previous step
run_poisson_regression <- function(data, formula) {
    glm(formula, data, family = poisson)
}

# Re-run the Poisson regression, using your function
model <- snake_river_visits %>%
  run_poisson_regression(n_visits ~ gender + income + travel)

# Run this to see the predictions
snake_river_explanatory %>%
  mutate(predicted_n_visits = predict(model, ., type = "response"))%>%
  arrange(desc(predicted_n_visits))


' All About Arguments '

'
Default arguments
toss_coin() troubles
toss_coin <- function(n_flips, p_head) {
    coin_sides <- c('head', 'tail')
    weights <- c(p_head, 1-p_head)
    sample(coin_sides, n_flips, replace=TRUE, prob=weights)
}

Set the default in the signature
toss_coin <- function(n_flips, p_head=0.5) {
    coin_sides <- c('head', 'tail')
    weights <- c(p_head, 1-p_head)
    sample(coin_sides, n_flips, replace=TRUE, prob=weights)
}

A template with defaults
my_fun <- function(data_arg1, data_arg2, detail_arg1=default1) {
    # Do something
}

Other types of default
args(median) -> in

function (x, na.rm=FALSE, ...) -> out

library(jsonlite)
args(fromJSON) -> in

function (txt, simplifyVector=TRUE, simplifyDataFrame=simplifyVector, simplifyMatrix=simplifyVector, flatten=FALSE, ...) -> out

NULL defaults
By convention, this means
    The function will do some special handling of this argument. Please read the docs.

args(set.seed) -> in

function (seed, kind=NULL, normal.kind=NULL) -> out

Categorical defaults
- Pass a character vector in the signature
- Call match.arg() in the body

args(prop.test) -> in

function (x, n, p=NULL, alternative=c('two.sided', 'less', 'greater'), conf.level=0.95, correct=TRUE)

Inside the body
alternative <- match.arg(alternative)

Cutting a vector by quantile
cut_by_quantile <- function(x, n, na.rm, labels, interval_type) {
    probs <- seq(0, 1, length.out=n+1)
    quantiles <- quantile(x, probs, na.rm=na.rm, names=FALSE)
    right <- switch(interval_type, '(lo, hi]'=TRUE, '[lo, hi)'=FALSE)
    cut(x, quantiles, labels=labels, right=right, include.lowest=TRUE)
}

- x : A numeric vector to cut
- n : The number of categories to cut x into
- na.rm : Should missing values be removed?
- labels : Character labels for the categories
- interval_type : Should ranges be open on the left or right?

Cat heart weights
data(cats, package='MASS')
quantile(cats$Hwt) -> in

0%      25%     50%     75%     100%
6.300   8.950   10.100  12.125  20.500  -> out

* The term for converting a numeric variable into a categorical variable is called 'cutting'.
cut(x, quantile(x))
'

# Set the default for n to 5
cut_by_quantile <- function(x, n=5, na.rm, labels, interval_type) {
    probs <- seq(0, 1, length.out = n + 1)
    qtiles <- quantile(x, probs, na.rm = na.rm, names = FALSE)
    right <- switch(interval_type, "(lo, hi]" = TRUE, "[lo, hi)" = FALSE)
    cut(x, qtiles, labels = labels, right = right, include.lowest = TRUE)
}

# Remove the n argument from the call
cut_by_quantile(
  n_visits, 
  na.rm = FALSE, 
  labels = c("very low", "low", "medium", "high", "very high"),
  interval_type = "(lo, hi]"
)


# Set the default for na.rm to FALSE
cut_by_quantile <- function(x, n = 5, na.rm = FALSE, labels, interval_type) {
    probs <- seq(0, 1, length.out = n + 1)
    qtiles <- quantile(x, probs, na.rm = na.rm, names = FALSE)
    right <- switch(interval_type, "(lo, hi]" = TRUE, "[lo, hi)" = FALSE)
    cut(x, qtiles, labels = labels, right = right, include.lowest = TRUE)
}

# Remove the na.rm argument from the call
cut_by_quantile(
  n_visits, 
  labels = c("very low", "low", "medium", "high", "very high"),
  interval_type = "(lo, hi]"
)


# Set the default for labels to NULL
cut_by_quantile <- function(x, n = 5, na.rm = FALSE, labels = NULL, interval_type) {
  probs <- seq(0, 1, length.out = n + 1)
  qtiles <- quantile(x, probs, na.rm = na.rm, names = FALSE)
  right <- switch(interval_type, "(lo, hi]" = TRUE, "[lo, hi)" = FALSE)
  cut(x, qtiles, labels = labels, right = right, include.lowest = TRUE)
}

# Remove the labels argument from the call
cut_by_quantile(
  n_visits,
  interval_type = "(lo, hi]"
)


# Set the categories for interval_type to "(lo, hi]" and "[lo, hi)"
cut_by_quantile <- function(x, n = 5, na.rm = FALSE, labels = NULL, 
                            interval_type = c('(lo, hi]', '[lo, hi)')) {
  # Match the interval_type argument
  interval_type <- match.arg(interval_type)
  probs <- seq(0, 1, length.out = n + 1)
  qtiles <- quantile(x, probs, na.rm = na.rm, names = FALSE)
  right <- switch(interval_type, "(lo, hi]" = TRUE, "[lo, hi)" = FALSE)
  cut(x, qtiles, labels = labels, right = right, include.lowest = TRUE)
}

# Remove the interval_type argument from the call
cut_by_quantile(n_visits)


'
Passing arguments between functions
Calculating the geometric mean
x %>%
  log() %>%
  mean() %>%
  exp()

Wrapping this in a function and Handling missing values
calc_geometric_mean <- function(x, na.rm=FALSE) {
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

Using ...
calc_geometric_mean <- function(x, ...) {
    x %>%
      log() %>%
      mean(...) %>%
      exp()
}

The tradeoff
Benefits
- Less typing for you
- No need to match signatures

Drawbacks
- You need to trust the inner function
- The interface is not as obvious to users
'

# Look at the Standard and Poor 500 data
glimpse(std_and_poor500)

# From previous steps
get_reciprocal <- function(x) {
    1 / x
}

calc_harmonic_mean <- function(x) {
    x %>%
      get_reciprocal() %>%
      mean() %>%
      get_reciprocal()
}

std_and_poor500 %>% 
  # Group by sector
  group_by(sector) %>% 
  # Summarize, calculating harmonic mean of P/E ratio
  summarize(hmean_pe_ratio = calc_harmonic_mean(pe_ratio))


# From previous step
calc_harmonic_mean <- function(x, na.rm = FALSE) {
  x %>%
    get_reciprocal() %>%
    mean(na.rm = na.rm) %>%
    get_reciprocal()
}

std_and_poor500 %>% 
  # Group by sector
  group_by(sector) %>% 
  # Summarize, calculating harmonic mean of P/E ratio
  summarize(hmean_pe_ratio = calc_harmonic_mean(pe_ratio, na.rm=TRUE))


calc_harmonic_mean <- function(x, ...) {
  x %>%
    get_reciprocal() %>%
    mean(...) %>%
    get_reciprocal()
}

std_and_poor500 %>% 
  # Group by sector
  group_by(sector) %>% 
  # Summarize, calculating harmonic mean of P/E ratio
  summarize(hmean_pe_ratio = calc_harmonic_mean(pe_ratio, na.rm=TRUE))


'
Checking arguments
* If the person who wrote the function made a mistake, then it"s called a bug.

The geometric mean
calc_geometric_mean <- function(x, na.rm=FALSE) {
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(letters) -> in

Error in log(.) : non-numeric argument to mathematical function -> out

Checking for numeric values
calc_geometric_mean <- function(x, na.rm=FALSE) {
    if(!is.numeric(x)) {
        stop("x is not of class 'numeric'; it has class '", class(x),  "'.")
    }  
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(letters) -> in

Error in calc_geometric_mean(letters) :
    x is not of class 'numeric'; it has class 'character'. -> out

assertive makes errors easy
Exciting : Handling errors with assertive
Boring : Writing boilerplat code to handle errors

Checking types of inputs
- assert_is_numeric()
- assert_is_character()
- is_data.frame()
- ...
- is_two_sided_formula()
- is_tskernel()

Using assertive to check x
calc_geometric_mean <- function(x, na.rm=FALSE) {
    assert_is_numeric(x)
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(letters) -> in

Error in calc_geometric_mean(letters) :
    is_numeric : x is not of class 'numeric'; it has class 'character'. -> out

Checking x is positive
calc_geometric_mean <- function(x, na.rm=FALSE) {
  assert_is_numeric(x)
  assert_all_are_positive(x)
  x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(c(1, -1)) -> in

Error in calc_geometric_mean(c(1, -1)) :
    is_positive : x contains non-positive values.
There was 1 failute:
    Position    Value     Cause
1          2       -1   too low  -> out

is_* functions
- assert_is_numeric()               * is_numeric() (returns logical value)
- assert_all_are_positive()         * is_positive() (returns logical vector)
                                    * is_non_positive() (returns logical vector)

Custom checks
calc_geometric_mean <- function(x, na.rm=FALSE) {
    assert_is_numeric(x)
    if(any(is_non_positive(x), na.rm=TRUE)) {
        stop("x contains non-positive values, so the geometric mean makes no sense.")
    }
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(c(1, -1)) -> in

Error in calc_geometric_mean(c(1, -1)) :
    x contains non-positive values, so the geometric mean makes no sense. -> out

Fixing input
use_first(c(1, 4, 9, 16)) -> in

[1] 1
Warning message:
Only the first value of c(1, 4, 9, 16) (=1) will be used. -> out

coerce_to(c(1, 4, 9, 16), 'character') -> in

[1] '1' '4' '9' '16'
Warning message:
Coercing c(1, 4, 9, 16) to class 'character'. -> out

Fixing na.rm
calc_geometric_mean <- function(x, na.rm=FALSE) {
    assert_is_numeric(x)
    if(any(is_non_positive(x), na.rm=TRUE)) {
        stop("x contains non-positive values, so the geometric mean makes no sense.")
    }
    na.rm <- coerce_to(use_first(na.rm), target_class='logical')
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

calc_geometric_mean(1:5, na.rm=1:5) -> in

[1] 2.605171
Warning messages:
1: Only the first value of na.rm (=1) will be used.
2: Coercing use_first(na.rm) to class 'logical'.
'

calc_harmonic_mean <- function(x, na.rm = FALSE) {
  # Assert that x is numeric
  assert_is_numeric(x)
  x %>%
    get_reciprocal() %>%
    mean(na.rm = na.rm) %>%
    get_reciprocal()
}

# See what happens when you pass it strings
calc_harmonic_mean(std_and_poor500$sector)


calc_harmonic_mean <- function(x, na.rm = FALSE) {
  assert_is_numeric(x)
  # Check if any values of x are non-positive
  if(any(is_non_positive(x), na.rm = TRUE)) {
    # Throw an error
    stop("x contains non-positive values, so the harmonic mean makes no sense.")
  }
  x %>%
    get_reciprocal() %>%
    mean(na.rm = na.rm) %>%
    get_reciprocal()
}

# See what happens when you pass it negative numbers
calc_harmonic_mean(std_and_poor500$pe_ratio - 20)


# Update the function definition to fix the na.rm argument
calc_harmonic_mean <- function(x, na.rm = FALSE) {
  assert_is_numeric(x)
  if(any(is_non_positive(x), na.rm = TRUE)) {
    stop("x contains non-positive values, so the harmonic mean makes no sense.")
  }
  # Use the first value of na.rm, and coerce to logical
  na.rm <- coerce_to(use_first(na.rm), target_class = "logical")
  x %>%
    get_reciprocal() %>%
    mean(na.rm = na.rm) %>%
    get_reciprocal()
}

# See what happens when you pass it malformed na.rm
calc_harmonic_mean(std_and_poor500$pe_ratio, na.rm = 1:5)


' Return Values and Scope '

'
Returning values from functions
A simple sum function
simple_sum <- function(x) {
    if(anyNA(x)) {
        return(NA)
    }
    total <- 0
    for(value in x) {
        total <- total + value
    }
    total
}

simple_sum(c(0, 1, 3, 6, NA, 7)) -> in

NA -> out

Returning NaN with a warning
calc_geometric_mean <- function(x, na.rm=FALSE) {
    assert_is_numeric(x)
    if(any(is_non_positive(x), na.rm=TRUE)) {
        warning("x contains non-positive values, so the geometric mean makes no sense.")
        return(NaN)
    }
    na.rm <- coerce_to(use_first(na.rm), target_class='logical')
    x %>%
      log() %>%
      mean(na.rm=na.rm) %>%
      exp()
}

Reasons for returning early
- You already know the answer
- The inout is an edge case

Hiding the return value
simple_sum <- function(x) {
    if(anyNA(x)) {
        return(NA)
    }
    total <- 0
    for(value in x) {
        total <- total + value
    }
    invisible(total)
}

simple_sum(c(0, 1, 3, 6, 2, 7)) -> in

    -> out

Many plots invisibly return things
ggplot(snake_river_visits, aes(n_visits)) + geom_histogram(binwidth=10)

str(srv_hist, max.level=0) -> in

List of 9
  - attr(*, 'class')= chr [1:2] 'gg' 'ggplot' -> out
'

is_leap_year <- function(year) {
  # If year is div. by 400 return TRUE
  if(is_divisible_by(year, 400)) {
    return(TRUE)
  }
  # If year is div. by 100 return FALSE
  if(is_divisible_by(year, 100)) {
    return(FALSE)
  }  
  # If year is div. by 4 return TRUE
  if(is_divisible_by(year, 4)) {
    return(TRUE)
  }
  
  # Otherwise return FALSE
  FALSE
}


# Using cars, draw a scatter plot of dist vs. speed
plt_dist_vs_speed <- plot(dist ~ speed, data = cars)

# Oh no! The plot object is NULL
plt_dist_vs_speed

# Define a pipeable plot fn with data and formula args
pipeable_plot <- function(data, formula) {
  # Call plot() with the formula interface
  plot(formula, data)
  # Invisibly return the input dataset
  invisible(data)
}

# Draw the scatter plot of dist vs. speed again
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Now the plot object has a value
plt_dist_vs_speed


'
Returning multiple values from functions
Getting the session information
R.version.string -> in

'R version 3.5.3 (2019-03-11)' -> out

Sys.info()[c('sysname', 'release')] -> in

sysname                                      release
'Linux'     '4.14.106-79.86.amzn1.x86_64' -> out

loadedNamespaces() -> in

[1] 'Rcpp'          'grDevices'     'crayon'
[4] 'dplyr'         'assertthat'    'R6'
[7] 'magrittr'      'datasets'      'pillar'
[10] 'rlang'        'utils'         'praise'
[13] 'rstudioapi'   'graphics'      'base'
[16] 'tools'        'glue'          'purrr'
[19] 'yaml'         'compiler'      'pkgconfig'
[22] 'stats'        'tidyselect'    'methods'
[25] 'tibble' -> out

Defining session()
session <- function() {
    list(
        r_version = R.version.string,
        operating_system = Sys.info()[c('sysname', 'release')],
        loaded_pkgs = loadedNamespaces()
    )
}

Calling session()
session() -> in

$r_version
[1] 'R version 3.5.3 (2019-03-11)'

$operating_system
sysname                                      release
'Linux'     '4.14.106-79.86.amzn1.x86_64'

$loaded_pkgs
[1] 'Rcpp'          'grDevices'     'crayon'
[4] 'dplyr'         'assertthat'    'R6'
[7] 'magrittr'      'datasets'      'pillar'
[10] 'rlang'        'utils'         'praise'
[13] 'rstudioapi'   'graphics'      'base'
[16] 'tools'        'glue'          'purrr'
[19] 'yaml'         'compiler'      'pkgconfig'
[22] 'stats'        'tidyselect'    'methods'
[25] 'tibble' -> out

Multi-assignment
library(zeallot)
c(vrsn, os, pkgs) %<-% session()

vrsn -> in

'R version 3.5.3 (2019-03-11)' -> out

os -> in

sysname                                      release
'Linux'     '4.14.106-79.86.amzn1.x86_64' -> out

Attributes
month_no <- setNames(1:12, month.abb)
month_no -> in

Jan   Feb Mar Apr May Jun Jul Aug Sep Oct  Nov Dec
    1   2   3   4   5   6   7   8   9  10   11  12 -> out

atributes(month_no) -> in

$names
[1] 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 
[8] 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' -> out

attr(month_no, 'names') -> in

[1] 'Jan' 'Feb' 'Mar' 'Apr' 'May' 'Jun' 'Jul' 
[8] 'Aug' 'Sep' 'Oct' 'Nov' 'Dec' -> out

attr(month_no, 'names') <- month.name
month_no -> in

January      February   March   April   May    June  July 
        1           2       3       4     5       6     7
August      September  October    November    December
        8           9       10          11          12 -> out

Attributes of a dataframe
data(Orange, package='datasets')

orange_trees -> in

# A tibble: 35 x 3
    Tree      age   circumference
    <ord>   <dbl>           <dbl>
1   1         118              30
2   1         484              58
3   1         664              87
4   1        1004             115
5   1        1231             120
6   1        1372             142
7   1        1582             145
8   2         118              33
9   2         484              69
10  2         664             111
# ... with 25 more rows -> out

attributes(orange_trees) -> in

$names
[1] 'Tree'          'age'
[3] 'circumference'

$row.names
[1] 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
[16] 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30
[31] 31 32 33 34 35

$class
[1] 'tbl_df'    'tbl'   'data.frame'  -> out

Attributes added by group_by()
library(dplyr)
orange_trees %>%
  group_by(Tree) %>%
  attributes() -> in

$names
[1] 'Tree'      'age'       'circumference'

$row.names
[1] 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18
[19] 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35

$class
[1] 'grouped_df'    'tbl_df'    'tbl'   'data.frame'  

$groups
# A tibble: 5 x 2

    Tree        .rows
    <ord>      <list>
1   3       <int [7]>
2   1       <int [7]>
3   5       <int [7]>
4   2       <int [7]>
5   4       <int [7]> -> out

When to use each technique
- If you need the result to have a particular type, add additional return values as attributes.
- Otherwise, collect all return values into a list.

broom
Model objects are converted into 3 data frames.
function          level                example
glance()          model     degrees of freedom
tidy()      coefficient               p-values
augment()   observation              residuals
'

# Look at the structure of model (it's a mess!)
str(model)

# Use broom tools to get a list of 3 data frames
list(
  # Get model-level values
  model = glance(model),
  # Get coefficient-level values
  coefficients = tidy(model),
  # Get observation-level values
  observations = augment(model)
)

# From previous step
groom_model <- function(model) {
    list(
        model = glance(model),
        coefficients = tidy(model),
        observations = augment(model)
    )
}

# Call groom_model on model, assigning to 3 variables
c(mdl, cff, obs) %<-% groom_model(model)

# See these individual variables
mdl; cff; obs


pipeable_plot <- function(data, formula) {
  plot(formula, data)
  # Add a "formula" attribute to data
  attr(data, 'formula') <- formula
  invisible(data)
}

# From previous exercise
plt_dist_vs_speed <- cars %>% 
  pipeable_plot(dist ~ speed)

# Examine the structure of the result
str(plt_dist_vs_speed)


'
Environments
Environments are like lists
datacamp_lst <- list(
  name = 'DataCamp'
  founding_year = 2013,
  website = 'https://www.datacamp.com'
)

ls.str(datacamp_lst) -> in

founding_year : num 2013,
name : chr 'DataCamp'
website : chr 'https://www.datacamp.com' -> out

datacamp_env <- list2env(datacamp_lst) 

ls.str(datacamp_env) -> in

founding_year : num 2013,
name : chr 'DataCamp'
website : chr 'https://www.datacamp.com' -> out

Getting the parent environment
parent <- parent.env(datacamp_env)
environmentName(parent) -> in

'R_GlobalEnv' -> out

grandparent <- parent.env(parent)
environmentName(grandparent) -> in

'package:stats' -> out

search() -> in 

[1] '.GlobalEnv'        'package:stats'
[3] 'package:graphics'  'package:grDevices'
[5] 'package:utils'     'package:datasets'
[7] 'package:methods'   'Autoloads'
[9] 'package:base' -> out

Does a variable exist?
datacamp_lst <- list(
  name = 'DataCamp',
  website = 'https://www.datacamp.com'
)
datacamp_env <- list2env(datacamp_lst)
founding_year <- 2013

exists('founding_year', envir=datacamp_env) -> in

TRUE -> out

exists('founding_year', envir=datacamp_env, inherits=FALSE) -> in

FALSE -> out
'

# From previous steps
rsa_lst <- list(
  capitals = capitals,
  national_parks = national_parks,
  population = population
)
rsa_env <- list2env(rsa_lst)

# Find the parent environment of rsa_env
parent <- parent.env(rsa_env)

# Print its name
environmentName(parent)


# Compare the contents of the global environment and rsa_env
ls.str(globalenv())
ls.str(rsa_env)

# Does population exist in rsa_env?
exists("population", envir = rsa_env)

# Does population exist in rsa_env, ignoring inheritance?
exists("population", envir = rsa_env, inherits=FALSE)


'
Scope and precedence
Accessing variables outside functions
x_times_y <- function(x) {
    x * y
} 

x_times_y(10) -> in

Error in x_times_y(10) :
    object 'y' not found -> out

x_times_y <- function(x) {
    x * y
} 
y <- 4

x_times_y(10) -> in

40 -> out

x_times_y <- function(x) {
    x * y
} 
y <- 4
x_times_y(10) -> in

print(x) -> in

Error in print(x) : object 'x' not found -> out

What"s best? Inside or outside?
x_times_y <- function(x) {
    y <- 6
    x * y
} 
y <- 4

x_times_y(10) -> in

60 -> out

Passed in vs defined in
x_times_y <- function(x) {
    x <- 9
    y <- 6
    x * y
} 
y <- 4

x_times_y(10) -> in

54 -> out
'


' Case Study on Grain Yields '

'
Grain yields and unit conversion
1 acre = area off land 2 oxen can plough in a day
1 hectare = 2 football fields
1 hectare = 150 New York apartments
1 bushel = 2 baskets of peaches
1 kilogram = 1 squirrel monkey

magrittr"s pipeable operator replacements
operator    functional alternative
x * y       x %>% multiply_by(y)
x ^ y       x %>% raise_to_power(y)
x[y]        x %>% extract(y)
'
There are 4840 square yards in an acre.
# Write a function to convert acres to sq. yards
acres_to_sq_yards <- function(acres) {
  acres * 4840
}

There are 36 inches in a yard and one inch is 0.0254 meters.
# Write a function to convert yards to meters
yards_to_meters <- function(yards) {
  yards * 36 * 0.0254
}

There are 10000 square meters in a hectare.
# Write a function to convert sq. meters to hectares
sq_meters_to_hectares <- function(sq_meters) {
  sq_meters / 10000
}


# Write a function to convert sq. yards to sq. meters
sq_yards_to_sq_meters <- function(sq_yards) {
  sq_yards %>%
    # Take the square root
    raise_to_power(0.5) %>%
    # Convert yards to meters
    yards_to_meters() %>%
    # Square it
    raise_to_power(2)
}

# Load the function from the previous step
load_step2()

# Write a function to convert acres to hectares
acres_to_hectares <- function(acres) {
  acres %>%
    # Convert acres to sq yards
    acres_to_sq_yards() %>%
    # Convert sq yards to sq meters
    sq_yards_to_sq_meters() %>%
    # Convert sq meters to hectares
    sq_meters_to_hectares()
}

# Load the functions from the previous steps
load_step3()

# Define a harmonic acres to hectares function
harmonic_acres_to_hectares <- function(acres) {
  acres %>% 
    # Get the reciprocal
    get_reciprocal() %>%
    # Convert acres to hectares
    acres_to_hectares() %>% 
    # Get the reciprocal again
    get_reciprocal()
}


# Write a function to convert lb to kg
lbs_to_kgs <- function(lbs) {
    lbs * 0.45359237 
}

# Write a function to convert bushels to lbs
bushels_to_lbs <- function(bushels, crop) {
  # Define a lookup table of scale factors
  c(barley = 48, corn = 56, wheat = 60) %>%
    # Extract the value for the crop
    extract(crop) %>%
    # Multiply by the no. of bushels
    multiply_by(bushels)
}

# Load fns defined in previous steps
load_step3()

# Write a function to convert bushels to kg
bushels_to_kgs <- function(bushels, crop) {
  bushels %>%
    # Convert bushels to lbs for this crop
    bushels_to_lbs(crop) %>%
    # Convert lbs to kgs
    lbs_to_kgs()
}

# Load fns defined in previous steps
load_step4()

# Write a function to convert bushels/acre to kg/ha
bushels_per_acre_to_kgs_per_hectare <- function(bushels_per_acre, crop = c("barley", "corn", "wheat")) {
  # Match the crop argument
  crop <- match.arg(crop)
  bushels_per_acre %>%
    # Convert bushels to kgs for this crop
    bushels_to_kgs(crop) %>%
    # Convert harmonic acres to ha
    harmonic_acres_to_hectares
}


# View the corn dataset
glimpse(corn)

corn %>%
  # Add some columns
  mutate(
    # Convert farmed area from acres to ha
    farmed_area_ha = acres_to_hectares(farmed_area_acres),
    # Convert yield from bushels/acre to kg/ha
    yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
      yield_bushels_per_acre,
      crop = "corn"
    )
  )

# Wrap this code into a function
fortify_with_metric_units <- function(data, crop) {
  data %>%
    mutate(
      farmed_area_ha = acres_to_hectares(farmed_area_acres),
      yield_kg_per_ha = bushels_per_acre_to_kgs_per_hectare(
        yield_bushels_per_acre, 
        crop = crop
      )
    )
}

# Try it on the wheat dataset
fortify_with_metric_units(wheat, 'wheat')


'
Visualizing grain yields
The corn dataset
glimpse(corn) -> in

Observations: 6,381
Variables: 6
$ year                      <int> 1866, 1866, 1866, 1866, 1866, 1866...
$ state                     <chr> 'Alabama', 'Arkansas', 'California'...
$ farmed_area_acres         <dbl> 1050000, 280000, 42000, 57000, 200...
$ yield_bushels_per_acre    <dbl> 9.0, 18.0, 28.0, 34.0, 23.0, 9.0, ...
$ farmed_area_ha            <dbl> 424919.92, 113311.98, 16996.80, 23...
$ yield_kg_per_ha           <dbl> 79.29892, 158.59784, 246.70776, 29... -> out

ggplot2: drawing multiple lines
ggplot(dataset, aes(x, y)) + geom_line(aes(group=group))

ggplot2: smooth trends
ggplot(dataset, aes(x, y)) + geom_line(aes(group=group)) + geom_smooth()

ggplot2: facetting
ggplot(dataset, aes(x, y)) + geom_line(aes(group=group)) + geom_smooth() + facet_wrap(vars(facet))

dplyr inner joins
dataset1 %>%
  inner_join(dataset2, by='column_to_join_on')
'

# Using corn, plot yield (kg/ha) vs. year
ggplot(corn, aes(year, yield_kg_per_ha)) +
  # Add a line layer, grouped by state
  geom_line(aes(group = state)) +
  # Add a smooth trend layer
  geom_smooth()

# Wrap this plotting code into a function
plot_yield_vs_year <- function(data) {
  ggplot(data, aes(year, yield_kg_per_ha)) +
    geom_line(aes(group = state)) +
    geom_smooth()
}

# Test it on the wheat dataset
plot_yield_vs_year(wheat)


# Inner join the corn dataset to usa_census_regions by state
corn %>%
  inner_join(usa_census_regions, on = "state")

# Wrap this code into a function
fortify_with_census_region <- function(data) {
  data %>%
    inner_join(usa_census_regions, by = "state")
}

# Try it on the wheat dataset
fortify_with_census_region(wheat)


# Plot yield vs. year for the corn dataset
plot_yield_vs_year(corn) +
  # Facet, wrapped by census region
  facet_wrap(vars(census_region))

# Wrap this code into a function
plot_yield_vs_year_by_region <- function(data) {
  plot_yield_vs_year(data) +
    facet_wrap(vars(census_region))
}

# Try it on the wheat dataset
plot_yield_vs_year_by_region(wheat)


'
Modeling grain yields
Linear models vs generalized additive models
A linear model
lm(
  response_var ~ explanatory_var1 + explanatory_var2,
  data = dataset
)

A generalized additive model
library(mgcv)
gam(
  response_var ~ s(explanatory_var1) + explanatory_var2,
  data = dataset
)

Predicting GAMs
predict_this <- data.frame(
  explanatory_var1 = c('some', 'values'),
  explanatory_var2 = c('more', 'values')
)

predicted_responses <- predict(model, predict_this, type='response')

predict_this %>%
  mutate(predicted_responses = predicted_responses)
'

# Run a generalized additive model of yield vs. smoothed year and census region
gam(yield_kg_per_ha ~ s(year) + census_region, data = corn)

# Wrap the model code into a function
run_gam_yield_vs_year_by_region <- function(data) {
  gam(yield_kg_per_ha ~ s(year) + census_region, data = data)
}

# Try it on the wheat dataset
run_gam_yield_vs_year_by_region(wheat)


# Make predictions in 2050  
predict_this <- data.frame(
  year = 2050,
  census_region = census_regions
) 

# Predict the yield
pred_yield_kg_per_ha <- predict(corn_model, predict_this, type = "response")

predict_this %>%
  # Add the prediction as a column of predict_this 
  mutate(pred_yield_kg_per_ha = pred_yield_kg_per_ha)

# Wrap this prediction code into a function
predict_yields <- function(model, year) {
  predict_this <- data.frame(
    year = year,
    census_region = census_regions
  ) 
  pred_yield_kg_per_ha <- predict(model, predict_this, type = "response")
  predict_this %>%
    mutate(pred_yield_kg_per_ha = pred_yield_kg_per_ha)
}

# Try it on the wheat dataset
predict_yields(wheat_model, 2050)


fortified_barley <- barley %>% 
  # Fortify with metric units
  fortify_with_metric_units() %>%
  # Fortify with census regions
  fortify_with_census_region()

# See the result
glimpse(fortified_barley)

# Plot yield vs. year by region
plot_yield_vs_year_by_region(fortified_barley)

fortified_barley %>% 
  # Run a GAM of yield vs. year by region
  run_gam_yield_vs_year_by_region()  %>% 
  # Make predictions of yields in 2050
  predict_yields(2050)