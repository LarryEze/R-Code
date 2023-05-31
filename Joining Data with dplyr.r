' Joining Tables '

'
The inner_join verb
'

c("part_cat_id" = "id")


'
Joining parts and part categories
The inner_join is the key to bring tables together. To use it, you need to provide the two tables that must be joined and the columns on which they should be joined.
'

# Add the correct verb, table, and joining column
parts %>% 
  inner_join(part_categories, by = c("part_cat_id" = "id"))

  print(parts)
  print(part_categories)


'
Joining with a one-to-many relationship
'

# Combine the parts and inventory_parts tables
parts %>%
  inner_join(inventory_parts, by = "part_num")

  print(parts)
  print(inventory_parts)


# Combine the parts and inventory_parts tables
inventory_parts %>%
  inner_join(parts, by = "part_num")


'
Joining three or more tables
'

sets %>%
  # Add inventories using an inner join 
  inner_join(inventories, by = "set_num") %>%
  # Add inventory_parts using an inner join 
  inner_join(inventory_parts, by = c("id" = "inventory_id")) 

  print(sets)
  print(inventories)
  print(inventory_parts)


# Add an inner join for the colors table
sets %>%
  inner_join(inventories, by = "set_num") %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  inner_join(colors, by = c("color_id" = "id"), suffix = c("_set", "_color"))

# Count the number of colors and sort
sets %>%
  inner_join(inventories, by = "set_num") %>%
  inner_join(inventory_parts, by = c("id" = "inventory_id")) %>%
  inner_join(colors, by = c("color_id" = "id"), suffix = c("_set", "_color")) %>%
  count(name_color, sort = TRUE)


' Left and Right Joins '

'
The left_join verb

Left joining two sets by color
'

# Combine the star_destroyer and millennium_falcon tables
millennium_falcon %>%
  left_join(star_destroyer, by = c("part_num", "color_id"), suffix = c("_falcon", "_star_destroyer"))


'
Finding an observation that doesn"t have a match
'

inventory_version_1 <- inventories %>%
  filter(version == 1)

# Join versions to sets
sets %>%
  left_join(inventory_version_1, by = c("set_num")) %>%
  # Filter for where version is na
  filter(is.na(version))


'
The right_join verb
'

parts %>%
  # Count the part_cat_id
  count(part_cat_id) %>%
  # Right join part_categories
  right_join(part_categories, by = c("part_cat_id" = "id"))

parts %>%
  count(part_cat_id) %>%
  right_join(part_categories, by = c("part_cat_id" = "id")) %>%
  # Filter for NA
  filter(is.na(n))


parts %>%
  count(part_cat_id) %>%
  right_join(part_categories, by = c("part_cat_id" = "id")) %>%
  # Use replace_na to replace missing values in the n column
  replace_na(list(n = 0))


'
Joining tables to themselves
'

themes %>% 
  # Inner join the themes table
  inner_join(themes, by = c("id" = "parent_id"), suffix = c("_parent", "_child")) %>%
  # Filter for the "Harry Potter" parent name 
  filter(name_parent == "Harry Potter")


# Join themes to itself again to find the grandchild relationships
themes %>% 
  inner_join(themes, by = c("id" = "parent_id"), suffix = c("_parent", "_child")) %>%
  inner_join(themes, by = c("id_child" = "parent_id"), suffix = c("_parent", "_grandchild"))

  print(themes)


themes %>% 
  # Left join the themes table to its own children
  left_join(themes, by = c("id" = "parent_id"), suffix = c("_parent", "_child")) %>%
  # Filter for themes that have no child themes
  filter(is.na(name_child))

  print(themes)


' Full, Semi, and Anti Joins '

'
The full_join verb
'

# Start with inventory_parts_joined table
inventory_parts_joined %>%
  # Combine with the sets table 
  inner_join(sets, by = c("set_num")) %>% 
  
  # Combine with the themes table 
  inner_join(themes, by = c("theme_id" = "id"), suffix = c("_set", "_theme"))

  print(inventory_parts_joined)
  print(sets)
  print(themes)


# Count the part number and color id, weight by quantity
batman %>%
  count(part_num, color_id, wt =quantity)

star_wars %>%
  count(part_num, color_id, wt = quantity)

print(batman)
print(star_wars)


batman_parts %>%
  # Combine the star_wars_parts table 
  full_join(star_wars_parts, by = c("part_num", "color_id"), suffix = c("_batman", "_star_wars")) %>%
  # Replace NAs with 0s in the n_batman and n_star_wars columns 
  replace_na(list(n_batman = 0, n_star_wars = 0))

  print(batman_parts)
  print(star_wars_parts)


parts_joined %>%
  # Sort the number of star wars pieces in descending order 
  arrange(desc(n_star_wars)) %>%
  # Join the colors table to the parts_joined table
  inner_join(colors, by = c("color_id" = "id")) %>%
  # Join the parts table to the previous join 
  inner_join(parts, by = c("part_num"), suffix = c("_color", "_part"))

  print(parts_joined)
  print(parts)
  print(colors)


'
The semi_join and anti_join verbs
'

# Filter the batwing set for parts that are also in the batmobile set
batwing %>%
  semi_join(batmobile, by = c("part_num"))

# Filter the batwing set for parts that aren't in the batmobile set
batwing %>%
  anti_join(batmobile, by = c("part_num"))


# Use inventory_parts to find colors included in at least one set
colors %>%
  semi_join(inventory_parts, by = c("id" = "color_id"))

  print(colors)
  print(inventory_parts)


# Use filter() to extract version 1 
version_1_inventories <- inventories %>%
  filter(version == 1)

# Use anti_join() to find which set is missing a version 1
sets %>%
  anti_join(version_1_inventories, by = c("set_num"))

  print(version_1_inventories)
  print(inventories)
  print(sets)


'
Visualizing set differences
'

batman_colors <- inventory_parts_themes %>%
  # Filter the inventory_parts_themes table for the Batman theme
  filter(name_theme == "Batman") %>%
  group_by(color_id) %>%
  summarize(total = sum(quantity)) %>%
  # Add a fraction column of the total divided by the sum of the total 
  mutate(fraction = total / sum(total))

# Filter and aggregate the Star Wars set data; add a fraction column
star_wars_colors <- inventory_parts_themes %>%
filter(name_theme == "Star Wars")%>%
group_by(color_id)%>%
summarize(total = sum(quantity))%>%
mutate(fraction = total / sum(total))

print(inventory_parts_themes)


batman_colors %>%
  # Join the Batman and Star Wars colors
  full_join(star_wars_colors, by = "color_id", suffix = c("_batman", "_star_wars")) %>%
  # Replace NAs in the total_batman and total_star_wars columns
  replace_na(list(total_batman = 0, total_star_wars = 0)) %>%
  inner_join(colors, by = c("color_id" = "id")) 


'
colors_joined <- batman_colors %>%
  full_join(star_wars_colors, by = "color_id", suffix = c("_batman", "_star_wars")) %>%
  replace_na(list(total_batman = 0, total_star_wars = 0)) %>%
  inner_join(colors, by = c("color_id" = "id")) %>%
  mutate(difference = fraction_batman - fraction_star_wars, total = total_batman + total_star_wars) %>%
  filter(total >= 200) %>%
  mutate(name = fct_reorder(name, difference)) 
'

# Create a bar plot using colors_joined and the name and difference columns
ggplot(colors_joined, aes(name, difference, fill = name)) + geom_col() + coord_flip() + scale_fill_manual(values = color_palette, guide = "none") + labs(y = "Difference: Batman - Star Wars")

print(colors_joined)


' Case Study: Joins on Stack Overflow Data '

'
Stack Overflow questions
'

# Replace the NAs in the tag_name column
questions %>%
  left_join(question_tags, by = c("id" = "question_id")) %>%
  left_join(tags, by = c("tag_id" = "id")) %>%
  replace_na(list("tag_name" = "only-r"))


questions_with_tags %>% 
  # Group by tag_name
  group_by(tag_name) %>%
  # Get mean score and num_questions
  summarize(score = mean(score), num_questions = n()) %>%
  # Sort num_questions in descending order
  arrange(desc(num_questions))

  print(questions_with_tags)


# Using a join, filter for tags that are never on an R question
tags %>%
  anti_join(question_tags, by = c("id" = "tag_id"))

  print(tags)
  print(question_tags)


questions %>%
  # Inner join questions and answers with proper suffixes
  inner_join(answers, by = c("id" = "question_id"), suffix = c("_question", "_answer")) %>%
  # Subtract creation_date_question from creation_date_answer to create gap
  mutate(gap = as.integer(creation_date_answer - creation_date_question))

  print(questions)
  print(answers)


# Count and sort the question id column in the answers table
answer_counts <- answers %>%
  count(question_id, sort = TRUE)

# Combine the answer_counts and questions tables
questions %>%
  left_join(answer_counts, by = c("id" = "question_id")) %>%
  # Replace the NAs in the n column
  replace_na(list("n" = 0))

  print(answer_counts)
  print(questions)


question_answer_counts %>%
  # Join the question_tags tables
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  # Join the tags table
  inner_join(tags, by = c("tag_id" = "id"))

  print(question_answer_counts)
  print(question_tags)
  print(tags)


tagged_answers %>%
  # Aggregate by tag_name
  group_by(tag_name)  %>%
  # Summarize questions and average_answers
  summarize(questions = n(), average_answers = mean(n)) %>%
  # Sort the questions in descending order
  arrange(desc(questions))

  print(tagged_answers)


# Inner join the question_tags and tags tables with the questions table
questions %>%
  inner_join(question_tags, by = c("id" = "question_id")) %>%
  inner_join(tags, by = c("tag_id" = "id"))

# Inner join the question_tags and tags tables with the answers table
answers %>%
  inner_join(question_tags, by = "question_id") %>%
  inner_join(tags, by = c("tag_id" = "id")) 

print(questions)
print(question_tags)
print(tags)
print(answers)


# Combine the two tables into posts_with_tags
posts_with_tags <- bind_rows(questions_with_tags %>% mutate(type = "question"), answers_with_tags %>% mutate(type = "answer"))

# Add a year column, then count by type, year, and tag_name
posts_with_tags %>%
  mutate(year = year(creation_date)) %>%
  count(type, year, tag_name)

# Filter for the dplyr and ggplot2 tag names 
by_type_year_tag_filtered <- by_type_year_tag %>%
  filter(tag_name %in% c("dplyr", "ggplot2"))

# Create a line plot faceted by the tag name 
ggplot(by_type_year_tag_filtered, aes(year, n, color = type)) + geom_line() + facet_wrap(~ tag_name)

print(by_type_year_tag_filtered)