####Chap9: Layers####
library(tidyverse)

#------------------------
# 9.2 Aesthetic mapping
#------------------------
mpg # 234 obsevations on 38 car models

ggplot(mpg, aes(x = displ, y = hwy, color = class)) +
  geom_point()

# only got 6 shapes, so one group would be upplotted
ggplot(mpg, aes(x = displ, y = hwy, shape = class)) +
  geom_point()

# use size to control the size of points
ggplot(mpg, aes(x = displ, y = hwy, size = class)) +
  geom_point()

# use alpha to control the transparency of the point
ggplot(mpg, aes(x = displ, y = hwy, alpha = class)) +
  geom_point()

# set the visual properties of your geom manually
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(color = "blue")

# Exercise
#1
ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point(color = "pink", shape = 17)

#2
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy), color = "blue")
# color should be outside of the aes

#3
ggplot(mpg, aes(x = hwy, y = displ)) +
  geom_point(stroke = 3, shape = 0)
#stroke: controls the thickness of the border around plotting shapes

#4
ggplot(mpg, aes(x = hwy, y = displ, color = displ < 5)) +
  geom_point()
# it turns out to be categorical variable


#------------------------------------------
# 9.3 Geometric objects
#------------------------------------------
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth()

# use different linetype to draw different line
# if you use shape, R will ignore it
ggplot(mpg, aes(x = displ, y = hwy, shape = drv)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, linetype = drv)) +
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(aes(linetype = drv))

# use "group" to draw multiple objects, but it will not show legend in default
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(color = drv), show.legend = F)

ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point(aes(color = class)) +  # only seen locally
  geom_smooth()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  geom_point(
    data = mpg |> filter(class == "2seater"),
    color = "red"
  ) +
  # following layer will overrides the previous layer
  geom_point(
    data = mpg |> filter(class == "2seater"),
    shape = "circle open", size = 3, color = "red"
  )

ggplot(mpg, aes(x = hwy)) +
  geom_histogram(binwidth = 2)

ggplot(mpg, aes(x = hwy)) +
  geom_density()

ggplot(mpg, aes(x = hwy)) +
  geom_boxplot()

# Exercise
#3
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = F)
# se: display confidence interval

#4
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = F) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(group = drv),se = F) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_smooth(se = F) +
  geom_point()

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(se = F) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_smooth(aes(linetype = drv), se = F) +
  geom_point(aes(color = drv))

ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
  geom_point(shape = 4,stroke = 1)

#-------------------------------
# 9.4 Facets
#-------------------------------
# facet_wrap(): splits a plot into subplots
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_wrap(~cyl)

# facet_grid(): double sided formula: rows ~ cols.
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point() +
  facet_grid(drv ~ cyl)

# scale = free: allow for different scales of  x or y-axis across columns
ggplot(mpg, aes(x = displ, y = hwy)) + 
  geom_point() + 
  facet_grid(drv ~ cyl, scales = "free")

# Exercise
#1 it will be a lot of little plot in the frame
#3 split data by only one variable while keeping a 2D layout
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)

#4 will be much more clear
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) + 
  facet_wrap(~ cyl, nrow = 2)

#6
ggplot(mpg, aes(x = displ)) + 
  geom_histogram() + 
  facet_grid(drv ~ .)

ggplot(mpg, aes(x = displ)) + 
  geom_histogram() +
  facet_grid(. ~ drv)


#7
ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)

ggplot(mpg) + 
  geom_point(aes(x = displ, y = hwy)) +
  facet_wrap(~drv)

#--------------------------------------
# 9.5 Statistical transformations
#--------------------------------------
diamonds

ggplot(diamonds, aes(x = cut)) +
  geom_bar()

diamonds |> 
  count(cut) |>
  ggplot(aes(x = cut, y = n)) +
  geom_bar(stat = "identity")
