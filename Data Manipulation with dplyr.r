' Transforming Data with dplyr '

'
Understanding your data
Take a look at the counties dataset using the glimpse() function.
'

counties %>%
# Select the columns
select(state, county, population, poverty)


counties_selected <- counties %>%
select(state, county, population, private_work, public_work, self_employed)

counties_selected %>%
# Add a verb to sort in descending order of public_work
arrange(desc(public_work))


counties_selected <- counties %>%  
select(state, county, population)

counties_selected %>%
# Filter for counties with a population above 1000000
filter(population > 1000000)


counties_selected <- counties %>%
select(state, county, population, private_work, public_work, self_employed)

# Filter for Texas and more than 10000 people; sort in descending order of private_work
counties_selected %>%
# Filter for Texas and more than 10000 people
filter(state == "Texas", population > 10000) %>%
# Sort in descending order of private_work
arrange(desc(private_work))


counties_selected <- counties %>%
select(state, county, population, public_work)

counties_selected %>%
# Add a new column public_workers with the number of people employed in public work
mutate( public_workers = population * public_work / 100 )

counties_selected %>%
mutate(public_workers = public_work * population / 100) %>%
# Sort in descending order of the public_workers column
arrange(desc(public_workers))


counties_selected <- counties %>%
# Select the columns state, county, population, men, and women
select(state, county, population, men, women)

counties_selected %>%
# Calculate proportion_women as the fraction of the population made up of women
mutate(proportion_women = women / population)


counties %>%
# Select the five columns 
select(state, county, population, men, women) %>%
# Add the proportion_men variable
mutate( proportion_men = men / population ) %>%
# Filter for population of at least 10,000
filter(population >= 10000) %>%
# Arrange proportion of men in descending order 
arrange(desc(proportion_men))


' Aggregating Data '

'
Counting by region
The counties dataset contains columns for region, state, population, and the number of citizens, which we selected and saved as the counties_selected table. In this exercise, you"ll focus on the region column.

counties_selected <- counties %>%
select(county, region, state, population, citizens)
'

# Use count to find the number of counties in each region
counties_selected %>%
count(region, sort = TRUE)


# Find number of counties per state, weighted by citizens, sorted in descending order
counties_selected %>%
count(state, wt = citizens, sort = TRUE)


counties_selected %>%
# Add population_walk containing the total number of people who walk to work 
mutate(population_walk = population * walk / 100) %>%
# Count weighted by the new column, sort in descending order
count(state, wt =  population_walk, sort = TRUE)


counties_selected %>%
# Summarize to find minimum population, maximum unemployment, and average income
summarize(min_population = min(population), max_unemployment = max(unemployment), average_income = mean(income))


counties_selected %>%
# Group by state 
group_by(state) %>%
# Find the total area and population
summarize(total_area = sum(land_area), total_population = sum(population))

counties_selected %>%
group_by(state) %>%
summarize(total_area = sum(land_area), total_population = sum(population)) %>%
# Add a density column
mutate(density = total_population / total_area) %>%
# Sort by density in descending order
arrange(desc(density))


counties_selected %>%
# Group and summarize to find the total population
group_by(region, state) %>%
summarize(total_pop = sum(population))

counties_selected %>%
# Group and summarize to find the total population
group_by(region, state) %>%
summarize(total_pop = sum(population)) %>%
# Calculate the average_pop and median_pop columns 
summarize(average_pop = mean(total_pop), median_pop = median(total_pop))


counties_selected %>%
# Group by region
group_by(region) %>%
# Find the greatest number of citizens who walk to work
top_n(1, walk)


'
Finding the lowest-income state in each region
You"ve been learning to combine multiple dplyr verbs together. Here, you"ll combine group_by(), summarize(), and slice_min() to find the state in each region with the highest income.

When you group by multiple columns and then summarize, it"s important to remember that the summarize "peels off" one of the groups, but leaves the rest on. For example, if you group_by(X, Y) then summarize, the result will still be grouped by X.

counties_selected <- counties %>%
select(region, state, county, population, income)
'

counties_selected %>%
group_by(region, state) %>%
# Calculate average income
summarize(average_income = mean(income)) %>%
# Find the highest income state in each region
top_n(1, average_income)


'
Using summarize, slice_max, and count together
In this chapter, you"ve learned to use six dplyr verbs related to aggregation: count(), group_by(), summarize(), ungroup(), slice_max(), and slice_min(). In this exercise, you"ll combine them to answer a question:

In how many states do more people live in metro areas than non-metro areas?

Recall that the metro column has one of the two values "Metro" (for high-density city areas) or "Nonmetro" (for suburban and country areas).

counties_selected <- counties %>%
select(state, metro, population)
'

counties_selected %>%
# Find the total population for each combination of state and metro
group_by(state, metro) %>%
summarize(total_pop = sum(population)) %>%
# Extract the most populated row for each state
top_n(1, total_pop) %>%
# Count the states with more people in Metro or Nonmetro areas
ungroup()%>%
count(metro)


' Selecting and Transforming Data '

'
Selecting columns
Using the select() verb, we can answer interesting questions about our dataset by focusing in on related groups of verbs. The colon (:) is useful for getting many columns at a time.
'

# Glimpse the counties table
glimpse(counties)

counties %>%
# Select state, county, population, and industry-related columns
select(state, county, population, professional:production) %>%
# Arrange service in descending order 
arrange(desc(service))


'
Renaming a column after count
The rename() verb is often useful for changing the name of a column that comes out of another verb, such as count(). In this exercise, you"ll rename the default n column generated from count() to something more descriptive.
'

counties %>%
# Count the number of counties in each state
count(state) %>%
# Rename the n column to num_counties
rename(num_counties = n)


'
Renaming a column as part of a select
rename() isn"t the only way you can choose a new name for a column; you can also choose a name as part of a select().
'

counties %>%
# Select state, county, and poverty as poverty_rate
select(state, county, poverty_rate = poverty)


'
you can think of transmute() as a combination of select() and mutate(), since you are getting back a subset of columns, but you are transforming and changing them at the same time.

Using transmute
The transmute verb allows you to control which variables you keep, which variables you calculate, and which variables you drop.
'

counties %>%
# Keep the state, county, and populations columns, and add a density column
transmute(state, county, population, density = population / land_area) %>%
# Filter for counties with a population greater than one million 
filter(population > 1000000) %>%
# Sort density in ascending order 
arrange(density)


# Change the name of the unemployment column
counties %>%
rename(unemployment_rate = unemployment)

# Keep the state and county columns, and the columns containing poverty
counties %>%
select(state, county, contains("poverty"))

# Calculate the fraction_women column without dropping the other columns
counties %>%
mutate(fraction_women = women / population)

# Keep only the state, county, and employment_rate columns
counties %>%
transmute(state, county, employment_rate = employed / population)


' Case Study: The babynames Dataset '

babynames %>%
# Filter for the year 1990
filter(year == 1990) %>%
# Sort the number column in descending order 
arrange(desc(number))


'
Finding the most popular names each year
You saw that you could use filter() and arrange() to find the most common names in one year. However, you could also use group_by() and slice_max() to find the most common name in every year.
'

babynames %>%
# Find the most common name in each year
group_by(year) %>%
top_n(1)


selected_names <- babynames %>%
# Filter for the names Steven, Thomas, and Matthew 
filter(name %in% c("Steven", "Thomas", "Matthew"))

# Plot the names using a different color for each name
ggplot(selected_names, aes(x = year, y = number, color = name)) + geom_line()


# Calculate the fraction of people born each year with the same name
babynames %>%
group_by(year) %>%
mutate(year_total = sum(number)) %>%
ungroup() %>%
mutate(fraction = number / year_total) %>%
# Find the year each name is most common
group_by(name) %>%
top_n(1)


babynames %>%
# Add columns name_total and name_max for each name
group_by(name) %>%
mutate(name_total = sum(number), name_max = max(number)) %>%
# Ungroup the table 
ungroup() %>%
# Add the fraction_max column containing the number by the name maximum 
mutate(fraction_max = number / name_max)


'
Visualizing the normalized change in popularity
You picked a few names and calculated each of them as a fraction of their peak. This is a type of "normalizing" a name, where you"re focused on the relative change within each name rather than the overall popularity of the name.

In this exercise, you"ll visualize the normalized popularity of each name. Your work from the previous exercise, names_normalized, has been provided for you.

names_normalized <- babynames %>%
group_by(name) %>%
mutate(name_total = sum(number), name_max = max(number)) %>%
ungroup() %>%
mutate(fraction_max = number / name_max)
'

names_filtered <- names_normalized %>%
# Filter for the names Steven, Thomas, and Matthew
filter(name %in% c("Steven", "Thomas", "Matthew")) 

# Visualize these names over time
ggplot(names_filtered, aes(x = year, y = fraction_max, color = name)) + geom_line()


'
Using ratios to describe the frequency of a name
You learned how to find the difference in the frequency of a baby name between consecutive years. What if instead of finding the difference, you wanted to find the ratio?

You"ll start with the babynames_fraction data already, so that you can consider the popularity of each name within each year.
'

babynames_fraction %>%
# Arrange the data in order of name, then year 
arrange(name, year) %>%
# Group the data by name
group_by(name) %>%

# Add a ratio column that contains the ratio of fraction between each year 
mutate(ratio = fraction / lag(fraction))


'
Biggest jumps in a name
Previously, you added a ratio column to describe the ratio of the frequency of a baby name between consecutive years to describe the changes in the popularity of a name. Now, you"ll look at a subset of that data, called babynames_ratios_filtered, to look further into the names that experienced the biggest jumps in popularity in consecutive years.

babynames_ratios_filtered <- babynames_fraction %>%
arrange(name, year) %>%
group_by(name) %>%
mutate(ratio = fraction / lag(fraction)) %>%
filter(fraction >= 0.00001)
'

babynames_ratios_filtered %>%
# Extract the largest ratio from each name 
top_n(1, ratio) %>%
# Sort the ratio column in descending order 
arrange(desc(ratio)) %>%
# Filter for fractions greater than or equal to 0.001
filter(fraction >= 0.001)