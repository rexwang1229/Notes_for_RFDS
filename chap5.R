####Chap5: Data Tidying####

library(tidyverse)

#-----------------------------
# 5.2 Tidy data
#-----------------------------
# interrelated rules that make a dataset tidy
# 1. Each variable is a column; each column is a variable.
# 2. Each observation is a row; each row is an observation.
# 3. Each value is a cell; each cell is a single value.

table1
table2
table3

# Compute rate per 10,000
table1 |> 
  mutate(rate = cases / population * 10000)

# Compute total cases per year
table1 |>
  group_by(year) |>
  mutate(total_cases = sum(cases))

# Visualize changes over time
ggplot(table1, aes(x = year, y = cases)) +
  geom_line(aes(group = country), color = "grey50") +
  geom_point(aes(color = country, shape = country)) +
  scale_x_continuous(breaks = c(1999, 2000))

# 5.2.1 Exercise
# 2
table2
table3
# 2a
a <- table2 |>
  group_by(country, year, type) |>
  summarise(TB_cases = sum(count)) |>
  filter(type == "cases") |>
  select(-type)

# 2b
b <- table2 |>
  group_by(country, year, type) |>
  summarise(Population = sum(count)) |>
  filter(type == "population") |>
  select(-type)

# 2c
c <- full_join(a, b)
d <- c |> mutate(rate = TB_cases / Population * 10000)
d

#------------------------------------
# 5.3 Lengthening data
#------------------------------------
billboard

# pivot_longer()
billboard |> pivot_longer(
  cols = starts_with("wk"), #specifies which columns aren’t variables,
  #!c(artist, track, date.entered),
  names_to = "week", #names the variable stored in the column names
  values_to = "rank", # names the variable stored in the cell values
  values_drop_na = TRUE
)

# converting values of week from character strings to numbers
billboard_longer <- billboard |>
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    values_to = "rank",
    values_drop_na = TRUE
  ) |>
  mutate(
    week = parse_number(week) #extract the first number from a string, ignoring all other text
  )
billboard_longer

billboard_longer |> 
  ggplot(aes(x = week, y = rank, group = track)) +
  geom_line(alpha = 0.25) +
  scale_y_reverse()

# Many variables in column names
# use pivot_longer() with a vector of column names for names_to
# instructors for splitting the original variable names into pieces for names_sep 
who2
who2 |>
  pivot_longer(
    cols = !(country:year),
    names_to = c("diagnosis", "gender", "age"),
    names_sep = "_", #用來分開不同colnames的方式
    values_to = "count"
  )

# Data and variable names in the column headers
# ".value" overrides the usual values_to argument 
# to use the first component of the pivoted column name as a variable name in the output.
# 想同時保有dob和name兩個欄位
household |> 
  pivot_longer(
    cols = !family,
    names_to = c(".value", "child"), #拆出的第一位當作欄位名
    names_sep = "_",
    values_drop_na = T
  )

#----------------------------------------------
# 5.4 Widening data
#----------------------------------------------
# makes datasets wider by increasing columns and reducing rows

cms_patient_experience

cms_patient_experience |>
  distinct(measure_cd, measure_title)

cms_patient_experience |>
  pivot_wider(
    names_from = measure_cd,
    values_from = prf_rate
  )

# tell which column or columns have values that uniquely identify each row
cms_patient_experience |>
  pivot_wider(
    id_cols = starts_with("org"),
    names_from = measure_cd,
    values_from = prf_rate
  )







