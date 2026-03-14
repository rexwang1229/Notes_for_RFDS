# Topic: Data Import
install.packages("janitor")
library(tidyverse)
library(janitor)

#-------------------------------------------------------
# 7.2 Reading data from a file
#-------------------------------------------------------

students <- read_csv("https://pos.it/r4ds-students-csv")
students

# read_csv() only recognizes empty strings ("") in this dataset as NAs
# we want it to also recognize the character string "N/A"
students <- read_csv("https://pos.it/r4ds-students-csv", na = c("N/A", ""))
students

# 變數中間有空格 -> non-syntactic names
students |>
  rename(
    student_id = `Student ID`,
    full_name = `Full Name`
  )

# janitor::clean_names() :use some heuristics to turn them all into snake case at once
students |> janitor::clean_names()

# make sure the data type is correct
students <- students |>
  janitor::clean_names() |>
  mutate(
    meal_plan = factor(meal_plan),
    age = parse_number(if_else(age == "five", "5", age))
  )

# trick to read text strings as a format of CSV file
read_csv(
  # first line will be the column names
  "a,b,c  
  1,2,3
  4,5,6"
)

read_csv(
  "The first line of metadata
  The second line of metadata
  x,y,z
  1,2,3",
  # use skip to decide which line should be column name
  skip = 2
)

read_csv(
  "# A comment I want to skip
  x,y,z
  1,2,3",
  # use commet = "#" to drop lines contain #
  comment = "#"
)

read_csv(
  "1,2,3
  4,5,6",
  # we don't want column name
  col_names = FALSE
)

read_csv(
  "1,2,3
  4,5,6",
  # use col_names to assign column names
  col_names = c("x", "y", "z")
)

# exercise 
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying
#a Extracting the variable called 1
annoying$`1`
#b Plotting a scatterplot of 1 vs. 2
ggplot(data = annoying, aes(x = `1`, y = `2`)) +
  geom_point()
#c Creating a new column called 3, which is 2 divided by 1
annoying <- annoying |>
  mutate(`3` = `2`/`1`)
#d Renaming the columns to one, two, and three.
annoying <- annoying |>
  rename(
    "one" = "1",
    "two" = "2",
    "three" = "3"
  )

#-----------------------------------
# 7.3 Controlling column types
#-----------------------------------
simple_csv <- "
  x
  10
  .
  20
  30"
read_csv(simple_csv) # it can't read . , so column x became character column

# tell readr that x is a numeric column and see where it fails
df <- read_csv(
  simple_csv,
  # col_types: takes a named list where the names match the column names in CSV file
  col_types = list(x = col_double()) 
)
# use problems() to see where is the problem
problems(df)
read_csv(simple_csv, na = ".") # 給定資料中na值的表示方式

# workflow: 匯入資料後發現資料型態不對 -> 試著直接更改 
# -> 利用col_type + problem()找出哪裡有問題
# column types function
# 使用邏輯 col_types = cols([columns_name] = [columns type function])
col_logical()
col_double()
col_integer()
col_character()
col_factor()
col_date()
col_datetime()
col_number()
col_skip() # skips a column so it’s not included in the result

another_csv <- "
x,y,z
1,2,3"

read_csv(another_csv)
# col_types強制所有欄位為character
# .default: 所有未特別指定的欄位
read_csv(
  another_csv,
  col_types = cols(.default = col_character()))
# col_only: 只讀取指定的欄位 (only take column x)
read_csv(
  another_csv, 
  col_types = cols_only(x = col_character())
)

#--------------------------------------------------
# 7.4 Reading data from multiple files
#--------------------------------------------------
sales_files <- c(
  "https://pos.it/r4ds-01-sales",
  "https://pos.it/r4ds-02-sales",
  "https://pos.it/r4ds-03-sales"
)
read_csv(sales_files, id = "file")

#--------------------------------------------------
# 7.5 Writing to a file
#--------------------------------------------------
write_csv(students, "data_path")

# when you reload the object, you are loading the exact same R object that you stored
write_rds()
read_rds
install.packages("arrow")
library(arrow)
write_parquet()
read_parquet()

# tibble and tribble
# tibble: by column
tibble(
  x = c(1, 2, 5), 
  y = c("h", "m", "g"),
  z = c(0.08, 0.83, 0.60)
)

# tribble: by row
tribble(
  ~x, ~y, ~z,
  1, "h", 0.08,
  2, "m", 0.83,
  5, "g", 0.60
)









