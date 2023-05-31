' Introduction '

'
Drawing your first plot
'

# Load the ggplot2 package
library(ggplot2)

# Explore the mtcars data frame with str()
str(mtcars)

# Execute the following command
ggplot(mtcars, aes(cyl, mpg)) + geom_point()


# Load the ggplot2 package
library(ggplot2)

# Change the command below so that cyl is treated as factor
ggplot(mtcars, aes(factor(cyl), mpg)) + geom_point()


'
The grammar of graphics
'

# Edit to add a color aesthetic mapped to disp
ggplot(mtcars, aes(wt, mpg, color = disp)) + geom_point()

# Change the color aesthetic to a size aesthetic
ggplot(mtcars, aes(wt, mpg, color = disp, size = disp)) + geom_point()


'
ggplot2 layers

Adding geometries
The diamonds dataset contains details of 1,000 diamonds. Among the variables included are carat (a measurement of the diamond"s size) and price.

You"ll use two common geom layer functions:

geom_point() adds points (as in a scatter plot).
geom_smooth() adds a smooth trend curve.

As you saw previously, these are added using the + operator.

ggplot(data, aes(x, y)) + geom_*()

Where * is the specific geometry needed.
'

# Explore the diamonds data frame with str()
str(diamonds)

# Add geom_point() with +
ggplot(diamonds, aes(carat, price)) + geom_point()

# Add geom_smooth() with +
ggplot(diamonds, aes(carat, price)) + geom_point() + geom_smooth()


# Map the color aesthetic to clarity
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point() +
  geom_smooth()

# Make the points 40% opaque
ggplot(diamonds, aes(carat, price, color = clarity)) +
  geom_point(alpha = 0.4) +
  geom_smooth()


# Draw a ggplot
plt_price_vs_carat <- ggplot(
  # Use the diamonds dataset
  diamonds,
  # For the aesthetics, map x to carat and y to price
  aes(carat, price)
)

# Add a point layer to plt_price_vs_carat
  geom_point()


# From previous step
plt_price_vs_carat <- ggplot(diamonds, aes(carat, price))

# Edit this to make points 20% opaque: plt_price_vs_carat_transparent
plt_price_vs_carat_transparent <- plt_price_vs_carat + geom_point(alpha = 0.2)

# See the plot
(plt_price_vs_carat_transparent)


# From previous step
plt_price_vs_carat <- ggplot(diamonds, aes(carat, price, color = clarity))

# Edit this to map color to clarity,
# Assign the updated plot to a new object
plt_price_vs_carat_by_clarity <- plt_price_vs_carat + geom_point(aes(color = clarity))

# See the plot
plt_price_vs_carat_by_clarity


' Aesthetics '

'
Visible aesthetics

All about aesthetics: color, shape and size
There are 9 visible aesthetics. Let"s apply them to a categorical variable — the cylinders in mtcars, cyl.

These are the aesthetics you can consider within aes() in this chapter: x, y, color, fill, size, alpha, labels and shape.

One common convention is that you don"t name the x and y arguments to aes(), since they almost always come first, but you do name other arguments.

In the following exercise the fcyl column is categorical. It is cyl transformed into a factor.
'

# Map x to mpg and y to fcyl
ggplot(mtcars, aes(mpg, fcyl)) +
  geom_point()

# Swap mpg and fcyl
ggplot(mtcars, aes(fcyl, mpg)) +
  geom_point()

# Map x to wt, y to mpg and color to fcyl
ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  geom_point()

ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Set the shape and size of the points
  geom_point(shape = 1, size = 4)


'
All about aesthetics: color vs. fill
Typically, the color aesthetic changes the outline of a geom and the fill aesthetic changes the inside. geom_point() is an exception: you use color (not fill) for the point color. However, some shapes have special behavior.

The default geom_point() uses shape = 19: a solid circle. An alternative is shape = 21: a circle that allow you to use both fill for the inside and color for the outline. This is lets you to map two aesthetics to each point.

All shape values are described on the points() help page.
'

# Map fcyl to fill
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  geom_point(shape = 1, size = 4)

ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  # Change point shape; set alpha
  geom_point(shape = 21, size = 4, alpha = 0.6)

# Map color to fam
ggplot(mtcars, aes(wt, mpg, fill = fcyl, color = fam)) +
  geom_point(shape = 21, size = 4, alpha = 0.6)


# Establish the base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Map fcyl to size
plt_mpg_vs_wt +
  geom_point(aes(size = fcyl))

# Base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Map fcyl to alpha, not size
plt_mpg_vs_wt +
  geom_point(aes(alpha = fcyl))

# Base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Map fcyl to shape, not alpha
plt_mpg_vs_wt +
  geom_point(aes(shape = fcyl))

# Base layer
plt_mpg_vs_wt <- ggplot(mtcars, aes(wt, mpg))

# Use text layer and map fcyl to label
plt_mpg_vs_wt +
  geom_text(aes(label = fcyl))


'
Using attributes

All about attributes: color, shape, size and alpha
This time you"ll use these arguments to set attributes of the plot, not map variables onto aesthetics.

You can specify colors in R using hex codes: a hash followed by two hexadecimal numbers each for red, green, and blue ("#RRGGBB"). Hexadecimal is base-16 counting. You have 0 to 9, and A representing 10 up to F representing 15. Pairs of hexadecimal numbers give you a range from 0 to 255. "#000000" is "black" (no color), "#FFFFFF" means "white", and `"#00FFFF" is cyan (mixed green and blue).
'

# A hexadecimal color
my_blue <- "#4ABEFF"

ggplot(mtcars, aes(wt, mpg)) +
  # Set the point color and alpha
  geom_point(color = my_blue, alpha = 0.6)

# A hexadecimal color
my_blue <- "#4ABEFF"

# Change the color mapping to a fill mapping
ggplot(mtcars, aes(wt, mpg, fill = fcyl)) +
  # Set point size and shape
  geom_point(color = my_blue, size = 10, shape = 1)


ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add point layer with alpha 0.5
  geom_point(alpha = 0.5)

ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add text layer with label rownames(mtcars) and color red
  geom_text(label = rownames(mtcars), color = "red")

ggplot(mtcars, aes(wt, mpg, color = fcyl)) +
  # Add points layer with shape 24 and color yellow
  geom_point(shape = 24, color = "yellow")


# 3 aesthetics: qsec vs. mpg, colored by fcyl
ggplot(mtcars, aes(mpg, qsec, color = fcyl)) + geom_point()

# 4 aesthetics: add a mapping of shape to fam
ggplot(mtcars, aes(mpg, qsec, color = fcyl, shape = fam)) +
  geom_point()

# 5 aesthetics: add a mapping of size to hp / wt
ggplot(mtcars, aes(mpg, qsec, color = fcyl, shape = fam, size = hp/wt)) +
  geom_point()


'
Modifying aesthetics

Updating aesthetic labels
In this exercise, you"ll modify some aesthetics to make a bar plot of the number of cylinders for cars with different types of transmission.

You"ll also make use of some functions for improving the appearance of the plot.

labs() to set the x- and y-axis labels. It takes strings for each argument.

scale_fill_manual() defines properties of the color scale (i.e. axis). The first argument sets the legend title. values is a named vector of colors to use.
'

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  # Set the axis labels
  labs(x = "Number of Cylinders", y = "Count") 

palette <- c(automatic = "#377EB8", manual = "#E41A1C")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  labs(x = "Number of Cylinders", y = "Count") +
  # Set the fill color scale
  scale_fill_manual("Transmission", values = palette)

palette <- c(automatic = "#377EB8", manual = "#E41A1C")

# Set the position
ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar(position = ("dodge")) +
  labs(x = "Number of Cylinders", y = "Count")
  scale_fill_manual("Transmission", values = palette)


'
You can make univariate plots in ggplot2, but you will need to add a fake y axis by mapping y to zero.

When using setting y-axis limits, you can specify the limits as separate arguments, or as a single numeric vector. That is, ylim(lo, hi) or ylim(c(lo, hi)).
'

# Plot 0 vs. mpg
ggplot(mtcars, aes(mpg, 0)) +
  # Add jitter 
  geom_point(position = "jitter")

ggplot(mtcars, aes(mpg, 0)) +
  geom_jitter() +
  # Set the y-axis limits
  ylim(-2, 2)


' Geometries '

'
Scatter plots

Overplotting 1: large datasets
Scatter plots (using geom_point()) are intuitive, easily understood, and very common, but we must always consider overplotting, particularly in the following four situations:

- Large datasets
- Aligned values on a single axis
- Low-precision data
- Integer data
Typically, alpha blending (i.e. adding transparency) is recommended when using solid shapes. Alternatively, you can use opaque, hollow shapes.

Small points are suitable for large datasets with regions of high density (lots of overlapping).
'

# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, aes(carat, price, color = clarity))

# Add a point layer with tiny points
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = ".")

# Plot price vs. carat, colored by clarity
plt_price_vs_carat_by_clarity <- ggplot(diamonds, aes(carat, price, color = clarity))

# Set transparency to 0.5
plt_price_vs_carat_by_clarity + geom_point(alpha = 0.5, shape = 16)


'
Overplotting 2: Aligned values
Let"s take a look at another case where we should be aware of overplotting: Aligning values on a single axis.

This occurs when one axis is continuous and the other is categorical, which can be overcome with some form of jittering.
'

# Plot base
plt_mpg_vs_fcyl_by_fam <- ggplot(mtcars, aes(fcyl, mpg, color = fam))

# Default points are shown for comparison
plt_mpg_vs_fcyl_by_fam + geom_point()

# Alter the point positions by jittering, width 0.3
plt_mpg_vs_fcyl_by_fam + geom_point(position = position_jitter(0.3))

# Now jitter and dodge the point positions
plt_mpg_vs_fcyl_by_fam + geom_point(position = position_jitterdodge(jitter.width = 0.3, dodge.width = 0.3))


'
Overplotting 3: Low-precision data
You already saw how to deal with overplotting when using geom_point() in two cases:

Large datasets
Aligned values on a single axis
We used position = 'jitter' inside geom_point() or geom_jitter().

Let"s take a look at another case:
Low-precision data
'

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Swap for jitter layer with width 0.1
  geom_jitter(alpha = 0.5, width = 0.1)

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Set the position to jitter
  geom_point(alpha = 0.5, position = "jitter")

ggplot(iris, aes(Sepal.Length, Sepal.Width, color = Species)) +
  # Use a jitter position function with width 0.1
  geom_point(alpha = 0.5, position = position_jitter(0.1))


'
Overplotting 4: Integer data
Let"s take a look at the last case of dealing with overplotting:

Integer data
This can be type integer (i.e. 1 ,2, 3…) or categorical (i.e. class factor) variables. factor is just a special class of type integer.

You"ll typically have a small, defined number of intersections between two variables, which is similar to case 3, but you may miss it if you don"t realize that integer and factor data are the same as low precision data.
'

# Examine the structure of Vocab
str(Vocab)

# Plot vocabulary vs. education
ggplot(Vocab, aes(education, vocabulary)) +
  # Add a point layer
  geom_point()

ggplot(Vocab, aes(education, vocabulary)) +
  # Change to a jitter layer
  geom_jitter()

ggplot(Vocab, aes(education, vocabulary)) +
  # Set the transparency to 0.2
  geom_jitter(alpha = 0.2)

ggplot(Vocab, aes(education, vocabulary)) +
  # Set the shape to 1
  geom_jitter(alpha = 0.2, shape = 1)


'
Histograms

Drawing histograms
Recall that histograms cut up a continuous variable into discrete bins and, by default, maps the internally calculated count variable (the number of observations in each bin) onto the y aesthetic. An internal variable called density can be accessed by using the .. notation, i.e. ..density... Plotting this variable will show the relative frequency, which is the height times the width of each bin.
'

ggplot(mtcars, aes(mpg)) +
  # Set the binwidth to 1
  geom_histogram(binwidth = 1)

# Map y to ..density..
ggplot(mtcars, aes(mpg, ..density..)) +
  geom_histogram(binwidth = 1)

datacamp_light_blue <- "#51A8C9"

ggplot(mtcars, aes(mpg, ..density..)) +
  # Set the fill color to datacamp_light_blue
  geom_histogram(binwidth = 1, fill = datacamp_light_blue)


'
Positions in histograms
Here, we"ll examine the various ways of applying positions to histograms. geom_histogram(), a special case of geom_bar(), has a position argument that can take on the following values:

- stack (the default): Bars for different groups are stacked on top of each other.
- dodge: Bars for different groups are placed side by side.
- fill: Bars for different groups are shown as proportions.
- identity: Plot the values as they appear in the dataset.
'

# Update the aesthetics so the fill color is by fam
ggplot(mtcars, aes(mpg, fill = fam)) +
  geom_histogram(binwidth = 1)

ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to dodge
  geom_histogram(binwidth = 1, position = "dodge")

ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to fill
  geom_histogram(binwidth = 1, position = "fill")

ggplot(mtcars, aes(mpg, fill = fam)) +
  # Change the position to identity, with transparency 0.4
  geom_histogram(binwidth = 1, position = "identity", alpha = 0.4)


'
Bar plots

Position in bar and col plots
Let"s see how the position argument changes geom_bar().

We have three position options:

- stack: The default
- dodge: Preferred
- fill: To show proportions
While we will be using geom_bar() here, note that the function geom_col() is just geom_bar() where both the position and stat arguments are set to "identity". It is used when we want the heights of the bars to represent the exact values in the data.
'

# Plot fcyl, filled by fam
ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Add a bar layer
  geom_bar()

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Set the position to "fill"
  geom_bar(position = "fill")

ggplot(mtcars, aes(fcyl, fill = fam)) +
  # Change the position to "dodge"
  geom_bar(position = "dodge")


'
Overlapping bar plots
You can customize bar plots further by adjusting the dodging so that your bars partially overlap each other. Instead of using position = "dodge", you"re going to use position_dodge(), like you did with position_jitter() in the the previous exercises. Here, you"ll save this as an object, posn_d, so that you can easily reuse it.

Remember, the reason you want to use position_dodge() (and position_jitter()) is to specify how much dodging (or jittering) you want.
'

ggplot(mtcars, aes(cyl, fill = fam)) +
  # Change position to use the functional form, with width 0.2
  geom_bar(position = position_dodge(width = 0.2))

ggplot(mtcars, aes(cyl, fill = fam)) +
  # Set the transparency to 0.6
  geom_bar(position = position_dodge(width = 0.2), alpha = 0.6)


'
Bar plots: sequential color palette
In this bar plot, we"ll fill each segment according to an ordinal variable. The best way to do that is with a sequential color palette.

Here"s an example of using a sequential color palette with the mtcars dataset:

ggplot(mtcars, aes(fcyl, fill = fam)) +
  geom_bar() +
  scale_fill_brewer(palette = "Set1")
'

# Plot education, filled by vocabulary
ggplot(Vocab, aes(education, fill = vocabulary)) +
  # Add a bar layer with position "fill"
  geom_bar(position = "fill") +
  # Add a brewer fill scale with default palette
  scale_fill_brewer()


'
Line plots
'

# Print the head of economics
head(economics)

# Using economics, plot unemploy vs. date
ggplot(economics, aes(date, unemploy)) +
  # Make it a line plot
  geom_line()

# Change the y-axis to the proportion of the population that is unemployed
ggplot(economics, aes(date, unemploy/pop)) +
  geom_line()


# Plot the Rainbow Salmon time series
ggplot(fish.species, aes(x = Year, y = Rainbow)) +
  geom_line()

# Plot the Pink Salmon time series
ggplot(fish.species, aes(x = Year, y = Pink)) +
  geom_line()

# Plot multiple time-series by grouping by species
ggplot(fish.tidy, aes(Year, Capture)) +
  geom_line(aes(group = Species))

# Plot multiple time-series by coloring by species
ggplot(fish.tidy, aes(x = Year, y = Capture, color = Species)) +
  geom_line()


' Themes '

'
Themes from scratch

Moving the legend
Let"s wrap up this course by making a publication-ready plot communicating a clear message.

To change stylistic elements of a plot, call theme() and set plot properties to a new value. For example, the following changes the legend position.

p + theme(legend.position = new_value)
Here, the new value can be

"top", "bottom", "left", or "right": place it at that side of the plot.
"none": don"t draw it.
c(x, y): c(0, 0) means the bottom-left and c(1, 1) means the top-right.
'

# View the default plot
plt_prop_unemployed_over_time

# Remove legend entirely
plt_prop_unemployed_over_time +
  theme(legend.position = "none")

# Position the legend at the bottom of the plot
plt_prop_unemployed_over_time +
  theme(legend.position = "bottom")

# Position the legend inside the plot at (0.6, 0.1)
plt_prop_unemployed_over_time +
  theme(legend.position = c(0.6, 0.1))


'
Modifying theme elements
Many plot elements have multiple properties that can be set. For example, line elements in the plot such as axes and gridlines have a color, a thickness (size), and a line type (solid line, dashed, or dotted). To set the style of a line, you use element_line(). For example, to make the axis lines into red, dashed lines, you would use the following.

p + theme(axis.line = element_line(color = "red", linetype = "dashed"))
Similarly, element_rect() changes rectangles and element_text() changes text. You can remove a plot element using element_blank().
'

plt_prop_unemployed_over_time + theme(
    # For all rectangles, set the fill color to grey92
    rect = element_rect(fill = "grey92"),
    # For the legend key, turn off the outline
    legend.key = element_rect(color = NA)
  )

plt_prop_unemployed_over_time + theme( rect = element_rect(fill = "grey92"), legend.key = element_rect(color = NA),
    # Turn off axis ticks
    axis.ticks = element_blank(),
    # Turn off the panel grid
    panel.grid = element_blank()
  )

plt_prop_unemployed_over_time + theme(rect = element_rect(fill = "grey92"), legend.key = element_rect(color = NA), axis.ticks = element_blank(), panel.grid = element_blank(),
    
    # Add major y-axis panel grid lines back
    panel.grid.major.y = element_line(
    # Set the color to white
    color = "white",
    # Set the size to 0.5
    size = 0.5,
    # Set the line type to dotted
    linetype = "dotted"
    )
  )

plt_prop_unemployed_over_time + theme(rect = element_rect(fill = "grey92"), legend.key = element_rect(color = NA), axis.ticks = element_blank(), panel.grid = element_blank(), panel.grid.major.y = element_line( color = "white", size = 0.5, linetype = "dotted"),
    
    # Set the axis text color to grey25
    axis.text = element_text(color = "grey25"),
    # Set the plot title font face to italic and font size to 16
    plot.title = element_text(size = 16, face = "italic")
  )


'
Modifying whitespace
Whitespace means all the non-visible margins and spacing in the plot.

To set a single whitespace value, use unit(x, unit), where x is the amount and unit is the unit of measure.

Borders require you to set 4 positions, so use margin(top, right, bottom, left, unit). To remember the margin order, think TRouBLe.

The default unit is "pt" (points), which scales well with text. Other options include "cm", "in" (inches) and "lines" (of text).
'

# View the original plot
plt_mpg_vs_wt_by_cyl

plt_mpg_vs_wt_by_cyl + theme(
    # Set the axis tick length to 2 lines
    axis.ticks.length = unit(2, "lines")
  )

plt_mpg_vs_wt_by_cyl + theme(
    # Set the legend key size to 3 centimeters
    legend.key.size = unit(3, "cm")
  )

plt_mpg_vs_wt_by_cyl + theme(
    # Set the legend margin to (20, 30, 40, 50) points
    legend.margin = margin(20, 30, 40, 50, "pt")
  )

plt_mpg_vs_wt_by_cyl + theme(
    # Set the plot margin to (10, 30, 50, 70) millimeters
    plot.margin = margin(10, 30, 50, 70, "mm")
  )


'
Theme flexibility

Built-in themes
In addition to making your own themes, there are several out-of-the-box solutions that may save you lots of time.

theme_gray() is the default.
theme_bw() is useful when you use transparency.
theme_classic() is more traditional.
theme_void() removes everything but the data.
'

# Add a black and white theme
plt_prop_unemployed_over_time + theme_bw()

# Add a classic theme
plt_prop_unemployed_over_time + theme_classic()

# Add a void theme
plt_prop_unemployed_over_time + theme_void()


# Use the fivethirtyeight theme
plt_prop_unemployed_over_time + theme_fivethirtyeight()

# Use Tufte's theme
plt_prop_unemployed_over_time + theme_tufte()

# Use the Wall Street Journal theme
plt_prop_unemployed_over_time + theme_wsj()


'
Setting themes
Reusing a theme across many plots helps to provide a consistent style. You have several options for this.

Assign the theme to a variable, and add it to each plot.
Set your theme as the default using theme_set().

A good strategy that you"ll use here is to begin with a built-in theme then modify it.
'

# Save the theme as theme_recession
theme_recession <- theme(
  rect = element_rect(fill = "grey92"),
  legend.key = element_rect(color = NA),
  axis.ticks = element_blank(),
  panel.grid = element_blank(),
  panel.grid.major.y = element_line(color = "white", size = 0.5, linetype = "dotted"),
  axis.text = element_text(color = "grey25"),
  plot.title = element_text(face = "italic", size = 16),
  legend.position = c(0.6, 0.1)
)

# Combine the Tufte theme with theme_recession
theme_tufte_recession <- theme_tufte() + theme_recession

# Add the Tufte recession theme to the plot.title
plt_prop_unemployed_over_time + theme_tufte_recession


theme_recession <- theme(
  rect = element_rect(fill = "grey92"),
  legend.key = element_rect(color = NA),
  axis.ticks = element_blank(),
  panel.grid = element_blank(),
  panel.grid.major.y = element_line(color = "white", size = 0.5, linetype = "dotted"),
  axis.text = element_text(color = "grey25"),
  plot.title = element_text(face = "italic", size = 16),
  legend.position = c(0.6, 0.1)
)
theme_tufte_recession <- theme_tufte() + theme_recession

# Set theme_tufte_recession as the default theme
theme_set(theme_tufte_recession)

# Draw the plot (without explicitly adding a theme_recession
plt_prop_unemployed_over_time


plt_prop_unemployed_over_time +
  # Add Tufte's theme
  theme_tufte()

plt_prop_unemployed_over_time + theme_tufte() +
  # Add individual theme elements
  theme(
    # Turn off the legend
    legend.position = "none",
    # Turn off the axis ticks
    axis.ticks = element_blank()
  )

plt_prop_unemployed_over_time + theme_tufte() +
  theme(
    legend.position = "none",
    axis.ticks = element_blank(),
    # Set the axis title's text color to grey60
    axis.title = element_text(color = "grey60"),
    # Set the axis text's text color to grey60
    axis.text = element_text(color = "grey60")
  )

plt_prop_unemployed_over_time + theme_tufte() +
  theme(
    legend.position = "none",
    axis.ticks = element_blank(),
    axis.title = element_text(color = "grey60"),
    axis.text = element_text(color = "grey60"),
    # Set the panel gridlines major y values
    panel.grid.major.y = element_line(
    # Set the color to grey60
    color = "grey60",
    # Set the size to 0.25
    size = 0.25,
    # Set the linetype to dotted
    linetype = "dotted"
    )
  )


'
Effective explanatory plots

Using annotate() for embellishments
In the previous exercise, we completed our basic plot. Now let"s polish it by playing with the theme and adding annotations. In this exercise, you"ll use annotate() to add text and a curve to the plot.

The following values have been calculated for you to assist with adding embellishments to the plot:

global_mean <- mean(gm2007_full$lifeExp)
x_start <- global_mean + 4
y_start <- 5.5
x_end <- global_mean
y_end <- 7.5
'

# Define the theme
plt_country_vs_lifeExp + theme_classic() +
  theme(axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        axis.text = element_text(color = "black"),
        axis.title = element_blank(),
        legend.position = "none")

# Add a vertical line
plt_country_vs_lifeExp + step_1_themes + geom_vline(xintercept = global_mean, color = "grey40", linetype = 3)

# Add text
plt_country_vs_lifeExp + step_1_themes + geom_vline(xintercept = global_mean, color = "grey40", linetype = 3) +
  annotate(
    "text",
    x = x_start, y = y_start,
    label = "The\nglobal\naverage",
    vjust = 1, size = 3, color = "grey40"
  )

# Add a curve
plt_country_vs_lifeExp + step_1_themes + geom_vline(xintercept = global_mean, color = "grey40", linetype = 3) +
  step_3_annotation +
  annotate(
    "curve",
    x = x_start, y = y_start,
    xend = x_end, yend = y_end,
    arrow = arrow(length = unit(0.2, "cm"), type = "closed"),
    color = "grey40"
  )