' Data wrangling '

# Load the gapminder package
library(gapminder)

# Load the dplyr package
library(dplyr)

# Look at the gapminder dataset
gapminder


'
Filtering for one year
The filter verb extracts particular observations based on a condition. In this exercise you"ll filter for observations from a particular year.
'

library(gapminder)
library(dplyr)

# Filter the gapminder dataset for the year 1957
gapminder %>% 
filter(year == 1957)


'
Filtering for one country and one year
You can also use the filter() verb to set two conditions, which could retrieve a single observation.

Just like in the last exercise, you can do this in two lines of code, starting with gapminder %>% and having the filter() on the second line. Keeping one verb on each line helps keep the code readable. Note that each time, you"ll put the pipe %>% at the end of the first line (like gapminder %>%); putting the pipe at the beginning of the second line will throw an error.
'

library(gapminder)
library(dplyr)

# Filter for China in 2002
gapminder %>%
filter(year == 2002 , country == "China")


'
Arranging observations by life expectancy
You use arrange() to sort observations in ascending or descending order of a particular variable. In this case, you"ll sort the dataset based on the lifeExp variable.
'

library(gapminder)
library(dplyr)

# Sort in ascending order of lifeExp
gapminder %>%
arrange(lifeExp)

# Sort in descending order of lifeExp
gapminder %>%
arrange(desc(lifeExp))


'
Filtering and arranging
You"ll often need to use the pipe operator (%>%) to combine multiple dplyr verbs in a row. In this case, you"ll combine a filter() with an arrange() to find the highest population countries in a particular year.
'

# Filter for the year 1957, then arrange in descending order of population
library(gapminder)
library(dplyr)

# Filter for the year 1957, then arrange in descending order of population
gapminder %>%
filter(year == 1957) %>%
arrange(desc(pop))


'
Using mutate to change or create a column
Suppose we want life expectancy to be measured in months instead of years: you"d have to multiply the existing value by 12. You can use the mutate() verb to change this column, or to create a new column that"s calculated this way
'

library(gapminder)
library(dplyr)

# Use mutate to change lifeExp to be in months
gapminder %>%
mutate(lifeExp = lifeExp * 12)

# Use mutate to create a new column called lifeExpMonths
gapminder %>%
mutate(lifeExpMonths = 12 * lifeExp)


' Combining filter, mutate, and arrange '

library(gapminder)
library(dplyr)

# Filter, mutate, and arrange the gapminder dataset
gapminder %>%
filter(year == 2007) %>%
mutate(lifeExpMonths = 12 * lifeExp) %>%
arrange(desc(lifeExpMonths))


' Data visualization '

'
Variable assignment
Throughout the exercises in this chapter, you"ll be visualizing a subset of the gapminder data from the year 1952. First, you"ll have to load the ggplot2 package, and create a gapminder_1952 dataset to visualize.
'

# Load the ggplot2 package as well
library(gapminder)
library(dplyr)
library(ggplot2)

# Create gapminder_1952
gapminder_1952 <- gapminder %>%
filter(year == 1952)


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Change to put pop on the x-axis and gdpPercap on the y-axis
ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) + geom_point()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Create a scatter plot with pop on the x-axis and lifeExp on the y-axis
ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) + geom_point()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Change this plot to put the x-axis on a log scale
ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) + geom_point() + scale_x_log10()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Scatter plot comparing pop and gdpPercap, with both axes on a log scale
ggplot(gapminder_1952, aes(x = pop, y = gdpPercap)) + geom_point() + scale_x_log10() + scale_y_log10()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Scatter plot comparing pop and lifeExp, with color representing continent
ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent)) + geom_point() + scale_x_log10()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Add the size aesthetic to represent a country's gdpPercap
ggplot(gapminder_1952, aes(x = pop, y = lifeExp, color = continent, size = gdpPercap)) + geom_point() + scale_x_log10()


' 
Creating a subgraph for each continent
You"ve learned to use faceting to divide a graph into subplots based on one of its variables, such as the continent.
'

library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Scatter plot comparing pop and lifeExp, faceted by continent
ggplot(gapminder_1952, aes(x = pop, y = lifeExp)) + geom_point() + scale_x_log10() + facet_wrap(~ continent)


library(gapminder)
library(dplyr)
library(ggplot2)

# Scatter plot comparing gdpPercap and lifeExp, with color representing continent
# and size representing population, faceted by year
ggplot(gapminder, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop)) + geom_point() + scale_x_log10() + facet_wrap(~ year)


' Grouping and summarizing '

'
Summarizing the median life expectancy
You"ve seen how to find the mean life expectancy and the total population across a set of observations, but mean() and sum() are only two of the functions R provides for summarizing a collection of numbers. Here, you"ll learn to use the median() function in combination with summarize().

By the way, dplyr displays some messages when it"s loaded that we"ve been hiding so far. They"ll show up in red and start with:

Attaching package: 'dplyr'

The following objects are masked from 'package:stats':
This will occur in future exercises each time you load dplyr: it"s mentioning some built-in functions that are overwritten by dplyr.
'

library(gapminder)
library(dplyr)

# Summarize to find the median life expectancy
gapminder %>%
summarize(medianLifeExp = median(lifeExp))


library(gapminder)
library(dplyr)

# Filter for 1957 then summarize the median life expectancy
gapminder %>%
filter(year == 1957) %>%
summarize(medianLifeExp = median(lifeExp))


'
Summarizing multiple variables in 1957
The summarize() verb allows you to summarize multiple variables at once. In this case, you"ll use the median() function to find the median life expectancy and the max() function to find the maximum GDP per capita.
'

library(gapminder)
library(dplyr)

# Filter for 1957 then summarize the median life expectancy and the maximum GDP per capita
gapminder %>%
filter(year == 1957) %>%
summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

'
The group_by verb
'

library(gapminder)
library(dplyr)

# Find median life expectancy and maximum GDP per capita in each year
gapminder %>%
group_by(year) %>%
summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))


library(gapminder)
library(dplyr)

# Find median life expectancy and maximum GDP per capita in each continent in 1957
gapminder %>%
filter(year == 1957) %>%
group_by(continent) %>%
summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))


library(gapminder)
library(dplyr)

# Find median life expectancy and maximum GDP per capita in each continent/year combination
gapminder %>%
group_by(year, continent) %>%
summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))


'
Visualizing median life expectancy over time
In the last chapter, you summarized the gapminder data to calculate the median life expectancy within each year. This code is provided for you, and is saved (with <-) as the by_year dataset.

Now you can use the ggplot2 package to turn this into a visualization of changing life expectancy over time.

* Add expand_limits(y = 0) so that the y-axis starts at zero.
'

library(gapminder)
library(dplyr)
library(ggplot2)

by_year <- gapminder %>%
group_by(year) %>%
summarize(medianLifeExp = median(lifeExp), maxGdpPercap = max(gdpPercap))

# Create a scatter plot showing the change in medianLifeExp over time
ggplot(by_year, aes(x = year, y = medianLifeExp)) + geom_point() + expand_limits(y = 0)


library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize medianGdpPercap within each continent within each year: by_year_continent
by_year_continent <- gapminder %>%
group_by(continent, year) %>%
summarize(medianGdpPercap = median(gdpPercap))

# Plot the change in medianGdpPercap in each continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap), color = continent) + geom_point() + expand_limits(y = 0)


library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize the median GDP and median life expectancy per continent in 2007
by_continent_2007 <- gapminder %>%
filter(year == 2007) %>%
group_by(continent) %>%
summarize(medianLifeExp = median(lifeExp), medianGdpPercap = median(gdpPercap))

# Use a scatter plot to compare the median GDP and median life expectancy
ggplot(by_continent_2007, aes(x = medianGdpPercap, y = medianLifeExp), color = continent) + geom_point() + expand_limits(y = 0)


' Types of visualizations '

'
Visualizing median GDP per capita over time
A line plot is useful for visualizing trends over time.
'

library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize the median gdpPercap by year, then save it as by_year
by_year <- gapminder %>%
group_by(year) %>%
summarize(medianGdpPercap = median(gdpPercap))

# Create a line plot showing the change in medianGdpPercap over time
ggplot(by_year, aes(x = year, y = medianGdpPercap)) + geom_line() + expand_limits(y = 0)


library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize the median gdpPercap by year & continent, save as by_year_continent
by_year_continent <- gapminder %>%
group_by(year, continent) %>%
summarize(medianGdpPercap = median(gdpPercap))

# Create a line plot showing the change in medianGdpPercap by continent over time
ggplot(by_year_continent, aes(x = year, y = medianGdpPercap), color = continent) + geom_line() + expand_limits(y = 0)


'
Visualizing median GDP per capita by continent
A bar plot is useful for visualizing summary statistics, such as the median GDP in each continent.
'

library(gapminder)
library(dplyr)
library(ggplot2)

# Summarize the median gdpPercap by continent in 1952
by_continent <- gapminder %>%
group_by(continent) %>%
filter(year == 1952) %>%
summarize(medianGdpPercap = median(gdpPercap))

# Create a bar plot showing medianGdp by continent
ggplot(by_continent, aes(y = medianGdpPercap, x = continent)) + geom_col()


library(gapminder)
library(dplyr)
library(ggplot2)

# Filter for observations in the Oceania continent in 1952
oceania_1952 <- gapminder %>%
filter(continent == "Oceania", year == 1952)

# Create a bar plot of gdpPercap by country
ggplot(oceania_1952, aes(x= country, y = gdpPercap)) + geom_col()


'
Visualizing population
A histogram is useful for examining the distribution of a numeric variable.
'

library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952) %>%
mutate(pop_by_mil = pop / 1000000)

# Create a histogram of population (pop_by_mil)
ggplot(gapminder_1952, aes(x = pop_by_mil)) + geom_histogram(bins = 50)


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Create a histogram of population (pop), with x on a log scale
ggplot(gapminder_1952, aes(x = pop)) + geom_histogram() + scale_x_log10()


'
Comparing GDP per capita across continents
A boxplot is useful for comparing a distribution of values across several groups.
'

library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Create a boxplot comparing gdpPercap among continents
ggplot(gapminder_1952, aes(y = gdpPercap, x = continent)) + geom_boxplot() + scale_y_log10()


library(gapminder)
library(dplyr)
library(ggplot2)

gapminder_1952 <- gapminder %>%
filter(year == 1952)

# Add a title to this graph: "Comparing GDP per capita across continents"
ggplot(gapminder_1952, aes(x = continent, y = gdpPercap)) + geom_boxplot() + scale_y_log10() + ggtitle("Comparing GDP per capita across continents")