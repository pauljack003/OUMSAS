# 9. Layers

## 9.2.1 Exercises

**1. Create a scatterplot of `hwy` vs. `displ` where the points are pink
filled in triangles.**

    ggplot(mpg, aes(x = displ, y = hwy,)) +
      geom_point(color = "pink", shape = 17)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-1-1.png)

**2. Why did the following code not result in a plot with blue points?**

    ggplot(mpg) + 
      geom_point(aes(x = displ, y = hwy, color = "blue"))

Color inside the aesthetic mapping can be associated with a variable,
but strict coloring would need to be defined outside the aesthetic and
tied to specific geom.

    ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(color = "blue")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-3-1.png)

**3. What does the stroke aesthetic do?**

It controls the size of the edge/border. If there isn’t a different
color defined for the edge/border, it will make the entire geom larger.

    ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(color = "blue", stroke = 5)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-4-1.png)

**4. What happens if you map an aesthetic to something other than a
variable name?**

It will create a Boolean value of T/F and display colors based on the
criteria given.

    ggplot(mpg, aes(x = hwy, y = displ, color = displ < 5)) + 
      geom_point()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-5-1.png)

## 9.3.1 Exercises

**1. What geom would you use to draw a line chart? A boxplot? A
histogram? An area chart?**

geom\_line, geom\_boxplot, geom\_histogram, geom\_area.

**2. Earlier in the chapter, we used `show.legend` … what does this
do?**

It defaults to TRUE, and would show a legend. By setting it to FALSE, no
legend is created.

**3. What does the `se` argument to geom\_smooth() do?**

It tells the geom whether to display standard error bands or not.

**4. Recreate the R code to generate the graphs shown in the text.**

    # First plot
    plot1 <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point() +
      geom_smooth(se = FALSE)

    # Second plot
    plot2 <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_smooth(aes(group = drv), se = FALSE) +
      geom_point()

    # Third plot
    plot3 <- ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
      geom_point() +
      geom_smooth(se = FALSE)

    # Fourth plot
    plot4 <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(aes(color = drv)) +
      geom_smooth(se = FALSE)

    # Fifth plot
    plot5 <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(aes(color = drv)) +
      geom_smooth(aes(linetype = drv), se = FALSE)

    # Sixth plot
    plot6 <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(size = 3, color = "white") +
      geom_point(aes(color=drv))

    # Combine all the plots into a 3x2 grid using patchwork
    library(patchwork)
    combined_plot <- (plot1 | plot2) / (plot3 | plot4) / (plot5 | plot6)
    combined_plot

    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'
    ## `geom_smooth()` using method = 'loess' and formula = 'y ~ x'

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-6-1.png)

## 9.4.1 Exercises

**1. What happens if you facet on a continuous variable?**

Whoo boy. You’ll get a facet for each unique instance of the continuous
variable. That could be a VERY large facet result set depending on the
nature of the data you have.

**2. What do the empty cells in the plot above with
`facet_grid(drv ~cyl)` mean? Run the code and discuss how they relate to
the resulting plot.**

    ggplot(mpg) + 
      geom_point(aes(x = drv, y = cyl)) +
      facet_grid(drv ~ cyl)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-7-1.png)

This output means there are no 4 wheel drive vehicles with 5 cylinders,
for example. Empty facets mean no observations were found in that
category.

**3. What plots does the following code make? What does `.` do?**

First plot: facet by rows, not columns Second plot: facet by columns,
not rows.

Facet statments are basically `row ~ column` statements, and the `.`
means to ignore that aspect.

    ggplot(mpg) + 
      geom_point(aes(x = displ, y = hwy)) +
      facet_grid(drv ~ .)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-8-1.png)

    ggplot(mpg) + 
      geom_point(aes(x = displ, y = hwy)) +
      facet_grid(. ~ cyl)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-8-2.png)

**4. Take the first faceted plot in this section: discuss the
advantages/disadvantages to using faceting vs. the color aesthetic.**

Faceting can make it much easier to isolate relationships that might get
lost in the larger picture, relationships that can get lost in
overplotting data. On the downside, it’s hard to compare classes to one
another as easily as can be done in a single color plot. It really will
depend on how many classes you’re looking at and how much data is in
each class. Overplotting is the root of data blindness in terms of
visual analysis, as they say.

    ggplot(mpg) + 
      geom_point(aes(x = displ, y = hwy)) + 
      facet_wrap(~ cyl, nrow = 2)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-9-1.png)

**5. Read ?facet\_wrap. What does `nrow` do? What does `ncol` do? What
other options control the layout of the individual panels? Why doesn’t
`facet_grid()` have `nrow` and `ncol` arguments?**

Well, nrow and ncol specify the number of panels that should be
arranged. This can be problematic if you specify values that don’t fit
the data you have – for example if `x` and `y` each are categorical with
6 values, that would be 36 possible plots. If I basically use
`facet_wrap` to specify a 2x2 output – it will only output the first
four plots.

This is why facet\_grid() doesn’t have these arguments. It’s designed to
create a grid showing all of the possible combinations.

**6. Which of the following plots makes it easier to compare engine size
(displ) across cars with different drive trains? What does this say
about when to place a faceting variable across rows or columns?**

    ggplot(mpg, aes(x = displ)) + 
      geom_histogram() + 
      facet_grid(drv ~ .)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-10-1.png)

    ggplot(mpg, aes(x = displ)) + 
      geom_histogram() +
      facet_grid(. ~ drv)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-10-2.png)

First one is much easier. If comparing a given variable, place it on the
shared axis when faceting.

**7. Recreate the following plot using `facet_wrap()` instead of
`facet_grid()`. How do the positions of the facet labels change?**

The labels move from the y to the x axis.

    ggplot(mpg) + 
      geom_point(aes(x = displ, y = hwy)) +
      facet_wrap(~ drv, nrow = 3)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-11-1.png)

## 9.5.1 Exercises

**1. What is the default geom associated with `stat_summary()`? How
could you rewrite the previous plot to use that geom function instead of
the stat function?**

    diamonds |>
      group_by(cut) |>
      summarize(
        lower = min(depth),
        upper = max(depth),
        midpoint = median(depth)
      ) |>
      ggplot(aes(x = cut, y = midpoint)) +
      geom_pointrange(aes(ymin = lower, ymax = upper))

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-12-1.png)

**2. What does `geom_col()` do? How is it different from `geom_bar()`?**

It makes a bar chart using the values in the data versus a count of the
number of cases.

**3. Most geoms and stats come in pairs that are almost always used in
concert. Make a list of all the pairs. What do they have in common?
(Hint: Read through the documentation.)**

    library(knitr)
    library(kableExtra)

    ## 
    ## Attaching package: 'kableExtra'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     group_rows

    # Create a data frame with the data
    data <- data.frame(
      geom = c("geom_bar()", "geom_bin2d()", "geom_boxplot()", "geom_contour_filled()", "geom_contour()", 
               "geom_count()", "geom_density_2d()", "geom_density()", "geom_dotplot()", "geom_function()", 
               "geom_sf()", "geom_sf()", "geom_smooth()", "geom_violin()", "geom_hex()", "geom_qq_line()", 
               "geom_qq()", "geom_quantile()"),
      stat = c("stat_count()", "stat_bin_2d()", "stat_boxplot()", "stat_contour_filled()", "stat_contour()", 
               "stat_sum()", "stat_density_2d()", "stat_density()", "stat_bindot()", "stat_function()", 
               "stat_sf()", "stat_sf()", "stat_smooth()", "stat_ydensity()", "stat_bin_hex()", "stat_qq_line()", 
               "stat_qq()", "stat_quantile()")
    )

    # Create the table
    kable(data, "html", escape = FALSE, col.names = c("geom", "stat")) %>%
      kable_styling(full_width = F, bootstrap_options = c("striped", "hover"))

<table class="table table-striped table-hover" style="color: black; width: auto !important; margin-left: auto; margin-right: auto;">
<thead>
<tr>
<th style="text-align:left;">
geom
</th>
<th style="text-align:left;">
stat
</th>
</tr>
</thead>
<tbody>
<tr>
<td style="text-align:left;">
geom\_bar()
</td>
<td style="text-align:left;">
stat\_count()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_bin2d()
</td>
<td style="text-align:left;">
stat\_bin\_2d()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_boxplot()
</td>
<td style="text-align:left;">
stat\_boxplot()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_contour\_filled()
</td>
<td style="text-align:left;">
stat\_contour\_filled()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_contour()
</td>
<td style="text-align:left;">
stat\_contour()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_count()
</td>
<td style="text-align:left;">
stat\_sum()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_density\_2d()
</td>
<td style="text-align:left;">
stat\_density\_2d()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_density()
</td>
<td style="text-align:left;">
stat\_density()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_dotplot()
</td>
<td style="text-align:left;">
stat\_bindot()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_function()
</td>
<td style="text-align:left;">
stat\_function()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_sf()
</td>
<td style="text-align:left;">
stat\_sf()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_sf()
</td>
<td style="text-align:left;">
stat\_sf()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_smooth()
</td>
<td style="text-align:left;">
stat\_smooth()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_violin()
</td>
<td style="text-align:left;">
stat\_ydensity()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_hex()
</td>
<td style="text-align:left;">
stat\_bin\_hex()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_qq\_line()
</td>
<td style="text-align:left;">
stat\_qq\_line()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_qq()
</td>
<td style="text-align:left;">
stat\_qq()
</td>
</tr>
<tr>
<td style="text-align:left;">
geom\_quantile()
</td>
<td style="text-align:left;">
stat\_quantile()
</td>
</tr>
</tbody>
</table>

**4. What variables does stat\_smooth() compute? What arguments control
its behavior?**

stat\_smooth() provides the following variables, some of which depend on
the orientation:

`after_stat(y)` or `after_stat(x)`: Predicted value.

`after_stat(ymin)` or `after_stat(xmin)`: Lower pointwise confidence
interval around the mean.

`after_stat(ymax)` or `after_stat(xmax)`: Upper pointwise confidence
interval around the mean.

`after_stat(se)`: Standard error.

**5. In our proportion bar chart, we needed to set group = 1. Why? In
other words, what is the problem with these two graphs?**

In the below code, the charts are looking at the proportion within each
group – so of course the proportion of fair diamonds that are fair will
= 1. By setting `group=1` we eliminate that so that the marginal
proportions vs the entire total can be calculated.

    ggplot(diamonds, aes(x = cut, y = after_stat(prop))) + 
      geom_bar()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-14-1.png)

    ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop))) + 
      geom_bar()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-14-2.png)

Here is the correct version:

    ggplot(diamonds, aes(x = cut, y = after_stat(prop), group = 1)) + 
      geom_bar()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-15-1.png)

    ggplot(diamonds, aes(x = cut, fill = color, y = after_stat(prop), group = color)) + 
      geom_bar()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-15-2.png)

## 9.6.1 Exercises

**1. What is the problem with the following plot? How could you improve
it?**

    ggplot(mpg, aes(x = cty, y = hwy)) + 
      geom_point()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-16-1.png)

Overplotting is the problem. We can use jitter to solve this.

    ggplot(mpg, aes(x = cty, y = hwy)) + 
      geom_jitter()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-17-1.png)

**2. What, if anything, is the difference between the two plots? Why?**

    ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-18-1.png)

    ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point(position = "identity")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-18-2.png)

There is no difference. This is because the geom\_point() function
defaults to the identity position.

**3. What parameters to geom\_jitter() control the amount of
jittering?**

Parameters `width=` and `height=` control the amount of jitter.

**4. Compare and contrast geom\_jitter() with geom\_count().**

`geom_jitter()` as we’ve seen adds some randomness to point positioning
in a plot. `geom_count()` does no such thing: it merely sizes the point
on the basis of the number of observations.

**5. What’s the default position adjustment for geom\_boxplot()? Create
a visualization of the mpg dataset that demonstrates it.**

The default position for a boxplot is `dodge2`. Here’s an example:

    ggplot(mpg, aes(y = hwy, color = class)) +
      geom_boxplot()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-19-1.png)

## 9.7.1 Exercises

**1. Turn a stacked bar chart into a pie chart using `coord_polar()`.**

    # Create a stacked bar chart
    stacked_bar <- ggplot(diamonds, aes(x = factor(1), fill = cut)) +
      geom_bar(width = 1)

    stacked_bar

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-20-1.png)

    stacked_bar + coord_polar(theta = "y")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-20-2.png)

**2. What’s the difference between coord\_quickmap() and coord\_map()?**

Not much. `coord_map()` is more of a proper 2d mapping of geographic
coordinates according to some named projection model. But that is
resource intensive and not very fast. That’s where `coord_quickmap()`
shines – it is an estimation of the one to one mapping process, and so
it is quicker and requires less computational overhead.

**3. What does the following plot tell you about the relationship
between city and highway mpg? Why is `coord_fixed()` important? What
does `geom_abline()` do?**

    ggplot(data = mpg, mapping = aes(x = cty, y = hwy)) +
      geom_point() + 
      geom_abline() +
      coord_fixed()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-21-1.png)

This plot adds a 45-degree reference line where hwy equals cty. This
line helps to visually compare city and highway fuel efficiencies;
points above the line indicate better highway efficiency than city
efficiency, while points below the line indicate the opposite.

We need `coord_fixed()` to ensure equal scaling for x and y axes,
otherwise the line might warp and lead to improper conclusions.

# 10. Exploratory data analysis

## 10.3.3 Exercises

**1. Explore the distribution of each of the x, y, and z variables in
diamonds. What do you learn?**

    library(gridExtra)

    ## 
    ## Attaching package: 'gridExtra'

    ## The following object is masked from 'package:dplyr':
    ## 
    ##     combine

    # a basic look at spread

    p1 <- ggplot(diamonds, aes(x = x)) + 
      geom_histogram(binwidth = 0.1) + 
      labs(title = "Distribution of x (Length)")

    p2 <- ggplot(diamonds, aes(x = y)) + 
      geom_histogram(binwidth = 0.1) + 
      labs(title = "Distribution of y (Width)")

    p3 <- ggplot(diamonds, aes(x = z)) + 
      geom_histogram(binwidth = 0.1) + 
      labs(title = "Distribution of z (Depth)")

    p4 <- ggplot(diamonds, aes(x = x, y = y)) + 
      geom_point(alpha = 0.3) + 
      labs(title = "Scatter plot of x (Length) vs y (Width)")

    grid.arrange(p1, p2, p3, p4, ncol = 2)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-22-1.png)

    # Boxplots

    # Boxplots with 3xIQR for outliers
    boxplot_x <- ggplot(diamonds, aes(y = x)) + 
      geom_boxplot(coef = 3) + 
      labs(title = "Boxplot of x (Length)")

    boxplot_y <- ggplot(diamonds, aes(y = y)) + 
      geom_boxplot(coef = 3) + 
      labs(title = "Boxplot of y (Width)")

    boxplot_z <- ggplot(diamonds, aes(y = z)) + 
      geom_boxplot(coef = 3) + 
      labs(title = "Boxplot of z (Depth)")

    grid.arrange(boxplot_x, boxplot_y, boxplot_z, ncol = 3)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-22-2.png)

Based off the charts above, a few items stand out for further inquiry:

-   All of the charts seem have zero values, meaning each variable has
    zero value entries. These would need to be investigated and possibly
    recoded into NA as appropriate (a zero width diamond, for example,
    doesn’t exist.)
-   Simiiarly, for `y` and `z`, the charts extend far out beyond the
    mass of most values, suggesting that one or two outliers sit there.
-   Boxplots clearly show the outliers for `y` and `z` that would need
    to be investigated further.

At the very least, starting with further exploration as shown will help
inform forward analysis of the data.

**2. Explore the distribution of price. Do you discover anything unusual
or surprising? (Hint: Carefully think about the binwidth and make sure
you try a wide range of values.) **

    summary(diamonds$price)

    ##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    ##     326     950    2401    3933    5324   18823

    p1 <- ggplot(diamonds, aes(x = price)) + 
      geom_histogram() + 
      labs(title = "Distribution of Diamond Prices", x = "Price", y = "Count")

    p2 <- ggplot(diamonds, aes(x = price)) + 
      geom_density() + 
      labs(title = "Density Plot of Diamond Prices", x = "Price", y = "Density")

    grid.arrange(p1, p2, nrow = 1)

    ## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-23-1.png)

The initial exploratory analysis here shows a right skew, which in some
ways make sense: most people arent buying super expensive diamonds. The
vast majority of diamonds sold are among the cheapest possible – in some
ways, this captures the “diamond is a diamond” philosophy. But there is
also a “bump in the data right before price = 5000, suggesting a cluster
or diamonds at the price point; it’s possible, for example, that this is
the most common price area for those looking for”nuptial diamonds” and
therefore demand is slightly greater around that price range.

We’ll change bins around here to see if the theses I mentioned above
bear out in the data as we get a better feel for it.

    # Smaller binwidth
    p3 <- ggplot(diamonds, aes(x = price)) + 
      geom_histogram(binwidth = 100) + 
      labs(title = "Distribution of Diamond Prices (Binwidth = 100)", x = "Price", y = "Count")

    # Larger binwidth
    p4 <- ggplot(diamonds, aes(x = price)) + 
      geom_histogram(binwidth = 1000) + 
      labs(title = "Distribution of Diamond Prices (Binwidth = 1000)", x = "Price", y = "Count")

    # Another example binwidth
    p5 <- ggplot(diamonds, aes(x = price)) + 
      geom_histogram(binwidth = 500) + 
      labs(title = "Distribution of Diamond Prices (Binwidth = 500)", x = "Price", y = "Count")

    grid.arrange(p3, p4, p5, ncol = 3)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-24-1.png)

Changing binwidths clearly demonstrates the second peak in price
activity just before $5,000.

**3. How many diamonds are 0.99 carat? How many are 1 carat? What do you
think is the cause of the difference?**

    count_0_99 <- sum(diamonds$carat == 0.99)
    count_1_00 <- sum(diamonds$carat == 1.00)

    count_0_99

    ## [1] 23

    count_1_00

    ## [1] 1558

Isn’t that interesting? Nobody wants a 0.99 carat diamond when they can
get a full carat. It’s likely, first of all, that no reasonable buyer
wants to be seen as a cheapskate by the object of their affection –
meaning explaining a 0.99 carat diamond vs going to the full carat is a
tough sell. This also may drive some price differences too as demand for
one carat is significantly more than demand for 0.99, meaning a linear
increase in price between these two weights isn’t likely to be observed.

**4. Compare and contrast coord\_cartesian() vs. xlim() or ylim() when
zooming in on a histogram. What happens if you leave binwidth unset?
What happens if you try and zoom so only half a bar shows? **

Using `xlim()` or `ylim()` recalcuated the data such that it’s
restricted within the bounds given – this can change how a histogram or
other distributional tool is calculated, and how it looks, depending on
the data. Partial bars will disappear, as well.

Using `coord_cartesian()` maintains the full data and integrity of
structure, including any partial bars. For this reason, I’d argue that
this is BY FAR the best way to “zoom in” on a part of a chart.

## 10.4.1 Exercises

**1. What happens to missing values in a histogram? What happens to
missing values in a bar chart? Why is there a difference in how missing
values are handled in histograms and bar charts?**

In a ggplot histogram, missing values are ignored although a message
will display summarizing how many records were omitted due to missing
values.

In a ggplot bar chart, missing values can cause the plot to fail
entirely because bar charts are summarizing categorical data – and an NA
will stop the operation completely. Here, to ensure you can proceed,
`na.rm = TRUE` is a best practice.

**2. What does na.rm = TRUE do in mean() and sum()?**

It removes NA values from the calculations.

**3. Recreate the frequency plot of scheduled\_dep\_time colored by
whether the flight was cancelled or not. Also facet by the cancelled
variable. Experiment with different values of the scales variable in the
faceting function to mitigate the effect of more non-cancelled flights
than cancelled flights.**

    nycflights13::flights |> 
      mutate(
        cancelled = is.na(dep_time),
        sched_hour = sched_dep_time %/% 100,
        sched_min = sched_dep_time %% 100,
        sched_dep_time = sched_hour + (sched_min / 60)
      ) |> 
      ggplot(aes(x = sched_dep_time)) + 
      geom_freqpoly(aes(color = cancelled), binwidth = 1/4) +
      facet_wrap(~cancelled, scales="free")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-26-1.png)

## 10.5.1.1 Exercises

**1. Use what you’ve learned to improve the visualization of the
departure times of cancelled vs. non-cancelled flights.**

I’ve decided here to use densities instead of counts to visualize the
data, as shown in the code and plots below.

    library(ggplot2)
    library(nycflights13)

    nycflights13::flights |> 
      mutate(
        cancelled = is.na(dep_time),
        sched_hour = sched_dep_time %/% 100,
        sched_min = sched_dep_time %% 100,
        sched_dep_time = sched_hour + (sched_min / 60)
      ) |> 
      ggplot(aes(x = sched_dep_time)) + 
      geom_freqpoly(aes(y = after_stat(density), color = cancelled), binwidth = 1/4) +
      facet_wrap(~cancelled, scales = "free") +
      labs(y = "Density", x = "Scheduled Departure Time", title = "Density of Scheduled Departure Times by Cancellation Status") +
      theme_minimal()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-27-1.png)

**2. Based on EDA, what variable in the diamonds dataset appears to be
most important for predicting the price of a diamond? How is that
variable correlated with cut? Why does the combination of those two
relationships lead to lower quality diamonds being more expensive?**

I don’t know that EDA can answer this question but some basic analysis
can. Let’s look at the available data; clean it for analysis; and
perform some basic analysis on it to find out what variable is the most
important for predicting the price of a diamond.

We start with a view into correlations - but first have to transform
some variables for analysis, as shown.

    library(corrplot)

    ## corrplot 0.94 loaded

    # Convert categorical variables to ordinal
    diamonds <- diamonds |> 
      mutate(
        cut_ord = as.numeric(factor(cut, levels = c("Fair", "Good", "Very Good", "Premium", "Ideal"))),
        color_ord = as.numeric(factor(color, levels = rev(c("D", "E", "F", "G", "H", "I", "J")))),
        clarity_ord = as.numeric(factor(clarity, levels = c("I1", "SI2", "SI1", "VS2", "VS1", "VVS2", "VVS1", "IF")))
      )

    # Select numeric variables
    numeric_vars <- diamonds |> 
      select(price, carat, cut_ord, color_ord, clarity_ord, depth, table, x, y, z)

    # Compute correlation matrix
    cor_matrix <- cor(numeric_vars, use = "complete.obs")

    # Visualize the correlation matrix
    corrplot(cor_matrix, method = "color", type = "upper", tl.cex = 0.7, tl.col = "black", addCoef.col = "black")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-28-1.png)
This analysis shows that `carat` is the most important variable
correlated positively with `price` (0.92 Pearson coefficient).

Looking in turn at `carat`, we can see that it is *negatively*
associated with `cut` (ie quality). This means that as carats increase,
the quality of the diamond tends to decrease. But this relationship
isn’t as strong as the correlation between `carat` and `price`.

Taken together, this means that bigger diamonds cost more, but tend to
be lower in quality as well. This may be a function of scarcity, meaning
that highest quality large diamonds are extremely rare. It may also
reflect market dynamics such that people are willing to pay a premium
for size even if that means trading off on quality.

**3. Instead of exchanging the x and y variables, add coord\_flip() as a
new layer to the vertical boxplot to create a horizontal one. How does
this compare to exchanging the variables? **

It does the exact same thing.

    ggplot(mpg, aes(x = fct_reorder(class, hwy, median), y = hwy)) +
      geom_boxplot() +
      coord_flip()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-29-1.png)

**4. One problem with boxplots is that they were developed in an era of
much smaller datasets and tend to display a prohibitively large number
of “outlying values”. One approach to remedy this problem is the letter
value plot. Install the lvplot package, and try using geom\_lv() to
display the distribution of price vs. cut. What do you learn? How do you
interpret the plots?**

    library(lvplot)

    ggplot(diamonds, aes(x = cut, y = price)) +
      geom_lv()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-30-1.png)

I honestly have ZERO idea how to interpret the chart above. I’d have to
go read about letter value plots, but what I see here doesn’t
immediately change any of my initial understanding of the data.

**5. Create a visualization of diamond prices vs. a categorical variable
from the diamonds dataset using geom\_violin(), then a faceted
geom\_histogram(), then a colored geom\_freqpoly(), and then a colored
geom\_density(). Compare and contrast the four plots. What are the pros
and cons of each method of visualizing the distribution of a numerical
variable based on the levels of a categorical variable? **

    # Violin plot
    ggplot(diamonds, aes(x = cut, y = price)) +
      geom_violin(fill = "skyblue", color = "black") 

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-31-1.png)

    # Faceted histogram 
    ggplot(diamonds, aes(x = price)) +
      geom_histogram(binwidth = 500, fill = "blue", color = "black") +
      facet_wrap(~cut)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-31-2.png)

    # Colored frequency polygon
    ggplot(diamonds, aes(x = price, color = cut)) +
      geom_freqpoly(binwidth = 500) 

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-31-3.png)

    # Colored density plot
    ggplot(diamonds, aes(x = price, color = cut, fill = cut)) +
      geom_density(alpha = 0.4)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-31-4.png)

**6. If you have a small dataset, it’s sometimes useful to use
geom\_jitter() to avoid overplotting to more easily see the relationship
between a continuous and categorical variable. The ggbeeswarm package
provides a number of methods similar to geom\_jitter(). List them and
briefly describe what each one does.**

1.  `geom_quasirandom()`: This geom spreads out the points within a
    category randomly, but with a preference for maintaining the overall
    shape of the distribution.

2.  `geom_beeswarm()`: This geom arranges points within a category in a
    “beeswarm” pattern. The points are positioned so that they don’t
    overlap, but they are packed tightly together.

3.  `geom_dotplot()`: This method stacks dots along the axis
    representing the continuous variable, with each dot representing one
    or more observations. The dots are stacked to avoid overlap, showing
    the distribution of values within each category.

## 10.5.2.1 Exercises

**1. How could you rescale the count dataset above to more clearly show
the distribution of cut within color, or color within cut?**

Two ways: first, change the color scheme as most people expect darker
colors to represent more density/higher counts. Secondly, change the
counts from raw number to proportions within each grouping. Code is
below for cut within color – the process to analyze color within cut
would be very similar. The resulting plot is much easier to understand.

    cut_within_color <- diamonds |> 
      count(color, cut) |> 
      group_by(color) |> 
      mutate(proportion = n / sum(n)) |> 
      ungroup()

    ggplot(cut_within_color, aes(x = color, y = cut)) +
      geom_tile(aes(fill = proportion)) +
      scale_fill_gradient(low = "lightblue", high = "darkblue")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-32-1.png)

**2. What different data insights do you get with a segmented bar chart
if color is mapped to the x aesthetic and cut is mapped to the fill
aesthetic? Calculate the counts that fall into each of the segments.**

    ggplot(diamonds, aes(x = color, fill = cut)) +
      geom_bar(position = "fill") 

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-33-1.png)

    #counts for each segment
    diamonds |> 
      count(color, cut)

    ## # A tibble: 35 × 3
    ##    color cut           n
    ##    <ord> <ord>     <int>
    ##  1 D     Fair        163
    ##  2 D     Good        662
    ##  3 D     Very Good  1513
    ##  4 D     Premium    1603
    ##  5 D     Ideal      2834
    ##  6 E     Fair        224
    ##  7 E     Good        933
    ##  8 E     Very Good  2400
    ##  9 E     Premium    2337
    ## 10 E     Ideal      3903
    ## # ℹ 25 more rows

**3. Use geom\_tile() together with dplyr to explore how average flight
departure delays vary by destination and month of year. What makes the
plot difficult to read? How could you improve it?**

The plot required is shown below. It’s tough to read because with so
many destinations on the y-axis, the plot is quickly crowded out
(although you can see that January and June sent to have the most active
delays). To fix this you might consider grouping destinations by
country.

    flights |> 
      ggplot(aes(x = month, y = dest)) +
        geom_tile(aes(fill=dep_delay)) +
        scale_fill_gradient(low = "lightblue", high = "darkblue")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-34-1.png)

## 10.5.3.1 Exercises

**1. Instead of summarizing the conditional distribution with a boxplot,
you could use a frequency polygon. What do you need to consider when
using cut\_width() vs. cut\_number()? How does that impact a
visualization of the 2d distribution of carat and price?**

Best to visualize these first as shown below.

    smaller <- diamonds |> 
      filter(carat < 3)

    # Using cut_width() to create frequency polygons
    p1 <- ggplot(smaller, aes(x = carat)) + 
      geom_freqpoly(aes(color = cut_width(carat, 0.1)), binwidth = 500) +
      labs(title = "Frequency Polygon Using cut_width()",
           x = "Carat",
           y = "Count")

    # Using cut_number() to create frequency polygons
    p2 <- ggplot(smaller, aes(x = carat)) + 
      geom_freqpoly(aes(color = cut_number(carat, 10)), binwidth = 500) +
      labs(title = "Frequency Polygon Using cut_number()",
           x = "Carat",
           y = "Count")

    grid.arrange(p1, p2, nrow = 1)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-35-1.png)

Generally speaking, `cut_width()` will break the data into however many
bins are needed to span the range of the variable in question – so in
the case of the carat data, we get quite a few fields and as you can
see, many end up with a very low frequency count.

Contrasted with `cut_number()`, which bins the data into a predefined
number of bins: this approach leads to more counts per bin and can
overcome the problem of low bin count, but it also can tend to being the
counts closer together, masking any distributional differences that
might be useful.

**2. Visualize the distribution of carat, partitioned by price.**

Best way to get at this is a violin plot, as shown.

    ggplot(diamonds, aes(x = cut_number(price, 5), y = carat)) +
      geom_violin(fill = "blue", color = "black") +
      labs(title = "Distribution of Carat, Partitioned by Price")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-36-1.png)

**3. How does the price distribution of very large diamonds compare to
small diamonds? Is it as you expect, or does it surprise you?**

    ggplot(diamonds, aes(x = cut_number(carat, 5), y = price)) +
      geom_violin(fill = "blue", color = "black") +
      labs(title = "Distribution of Price, Partitioned by Carat")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-37-1.png)

The plot above shows very different distributions of price for the
largest diamonds vs. the smallest. Globally speaking, the fact that
prices for the smallest diamonds are clustered towards the lower end of
price overall should not be a suprise. What is surprising, perhaps, is
that the prices for the largest diamonds exhibit wide spread – which
partly reflects the low number of observations in that higher end of the
diamond market.

**4. Combine two of the techniques you’ve learned to visualize the
combined distribution of cut, carat, and price.**

    ggplot(diamonds, aes(x = carat, color = cut_number(price, 4))) +
      geom_density() +
      facet_wrap(~ cut) +
      labs(title = "Combined Distribution of Cut, Carat, and Price",
           x = "Carat",
           y = "Density",
           color = "Price Bins")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-38-1.png)

**5. Two dimensional plots reveal outliers that are not visible in one
dimensional plots. For example, some points in the following plot have
an unusual combination of x and y values, which makes the points
outliers even though their x and y values appear normal when examined
separately. Why is a scatterplot a better display than a binned plot for
this case?**

    diamonds |> 
      filter(x >= 4) |> 
      ggplot(aes(x = x, y = y)) +
      geom_point() +
      coord_cartesian(xlim = c(4, 11), ylim = c(4, 11))

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-39-1.png)

Outliers in multivariate data are often defined by unusual combinations
of values across multiple dimensions. In this case, while both x and y
might seem normal on their own, their combination might be highly
unusual. A scatterplot makes it easy to identify these multivariate
outliers because you can visually assess the relationship between x and
y directly.

**6. Instead of creating boxes of equal width with cut\_width(), we
could create boxes that contain roughly equal number of points with
cut\_number(). What are the advantages and disadvantages of this
approach?**

    ggplot(smaller, aes(x = carat, y = price)) + 
      geom_boxplot(aes(group = cut_number(carat, 20)))

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-40-1.png)

Here, the biggest change is that the width of each box in the boxplot
contains 20 observations – so if the box is VERY wide, that means it had
to cover a lot of range to fill 20 observations (meaning sample data is
sparse in that area). If, on the other hand, boxes are small and nearly
invisible to see, this means there is a lot of data in that space and
filling bins of 20 observations requires little span of range.

**BONUS. Models are a tool for extracting patterns out of data. For
example, consider the diamonds data. It’s hard to understand the
relationship between cut and price, because cut and carat, and carat and
price are tightly related. It’s possible to use a model to remove the
very strong relationship between price and carat so we can explore the
subtleties that remain. The following code fits a model that predicts
price from carat and then computes the residuals (the difference between
the predicted value and the actual value). The residuals give us a view
of the price of the diamond, once the effect of carat has been removed.
Note that instead of using the raw values of price and carat, we log
transform them first, and fit a model to the log-transformed values.
Then, we exponentiate the residuals to put them back in the scale of raw
prices.**

    library(tidymodels)

    ## ── Attaching packages ────────────────────────────────────── tidymodels 1.2.0 ──

    ## ✔ broom        1.0.6     ✔ rsample      1.2.1
    ## ✔ dials        1.3.0     ✔ tune         1.2.1
    ## ✔ infer        1.0.7     ✔ workflows    1.1.4
    ## ✔ modeldata    1.4.0     ✔ workflowsets 1.1.0
    ## ✔ parsnip      1.2.1     ✔ yardstick    1.3.1
    ## ✔ recipes      1.1.0

    ## ── Conflicts ───────────────────────────────────────── tidymodels_conflicts() ──
    ## ✖ gridExtra::combine()     masks dplyr::combine()
    ## ✖ scales::discard()        masks purrr::discard()
    ## ✖ dplyr::filter()          masks stats::filter()
    ## ✖ recipes::fixed()         masks stringr::fixed()
    ## ✖ kableExtra::group_rows() masks dplyr::group_rows()
    ## ✖ dplyr::lag()             masks stats::lag()
    ## ✖ yardstick::spec()        masks readr::spec()
    ## ✖ recipes::step()          masks stats::step()
    ## • Search for functions across packages at https://www.tidymodels.org/find/

    diamonds <- diamonds |>
      mutate(
        log_price = log(price),
        log_carat = log(carat)
      )

    diamonds_fit <- linear_reg() |>
      fit(log_price ~ log_carat, data = diamonds)

    diamonds_aug <- augment(diamonds_fit, new_data = diamonds) |>
      mutate(.resid = exp(.resid))

    ggplot(diamonds_aug, aes(x = carat, y = .resid)) + 
      geom_point()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-41-1.png)

# 11. Communication

## 11.2.1 Exercises

**1. Create one plot on the fuel economy data with customized title,
subtitle, caption, x, y, and color labels.**

    ggplot(mpg, aes(x = displ, y = hwy, color = drv)) +
      geom_point() +
      labs(
        x = "Engine displacement (L)",
        y = "Highway fuel economy (mpg)",
        color = "Drive type",
        title = "Fuel efficiency generally decreases with engine size",
        subtitle = "Rear wheel drive (r) is the exception here for an unknown reason",
        caption = "All data from mpg dataset"
      )

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-42-1.png)

**2. Recreate the following plot using the fuel economy data. Note that
both the colors and shapes of points vary by type of drive train.**

    ggplot(mpg, aes(x = cty, y = hwy, color = drv, shape = drv)) +
      geom_point() +
      coord_cartesian()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-43-1.png)

**3. Take an exploratory graphic that you’ve created in the last month,
and add informative titles to make it easier for others to understand.**

    ggplot(diamonds, aes(x = cut_number(carat, 5), y = price)) +
      geom_violin(fill = "blue", color = "black") +
      labs(
        x = "Carat size of diamond",
        y = "Price of diamond ($)",
        title = "The price of diamonds changes as carats increase",
        subtitle = "Higher carats lead to widening differences in pricing (shown as elongation here)",
        caption = "data from diamonds dataset"
        )

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-44-1.png)

## 11.3.1 Exercises

**1. Use geom\_text() with infinite positions to place text at the four
corners of the plot.**

    ggplot()+
      geom_point(data = mpg, aes(x = displ, y = hwy)) +
      geom_text(aes(x = -Inf, y = Inf, label = "Top Left"), hjust = -0.1, vjust = 1.1) +
      geom_text(aes(x = Inf, y = Inf, label = "Top Right"), hjust = 1.1, vjust = 1.1) +
      geom_text(aes(x = -Inf, y = -Inf, label = "Bottom Left"), hjust = -0.1, vjust = -0.1) +
      geom_text(aes(x = Inf, y = -Inf, label = "Bottom Right"), hjust = 1.1, vjust = -0.1)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-45-1.png)

**2. Use annotate() to add a point geom in the middle of your last plot
without having to create a tibble. Customize the shape, size, or color
of the point.**

    ggplot()+
      geom_point(data = mpg, aes(x = displ, y = hwy)) +
      geom_text(aes(x = -Inf, y = Inf, label = "Top Left"), hjust = -0.1, vjust = 1.1) +
      geom_text(aes(x = Inf, y = Inf, label = "Top Right"), hjust = 1.1, vjust = 1.1) +
      geom_text(aes(x = -Inf, y = -Inf, label = "Bottom Left"), hjust = -0.1, vjust = -0.1) +
      geom_text(aes(x = Inf, y = -Inf, label = "Bottom Right"), hjust = 1.1, vjust = -0.1) +
      annotate("point", x = 4, y = 30, shape = 17, size = 5, color = "red")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-46-1.png)

**3. How do labels with geom\_text() interact with faceting? How can you
add a label to a single facet? How can you put a different label in each
facet? (Hint: Think about the dataset that is being passed to
geom\_text().)**

If the data passed to `geom_text()` is in the facet, then the geom
object will be shown; otherwise it will not. So to get a label to show
in only a single facet, you have to ensure that the data passed to
`geom_text()` is only for that specific facet. To have a different label
in each facet, you’d need to ensure you’re passing the approriate data
split on whatever dimensionality the facet is using. An example is
below:

    #put the plot into an object, it won't show
    plot <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point() +
      facet_wrap(~ drv)

    # Create a dataset for labels
    label_data <- data.frame(
      drv = c("4", "f", "r"),
      label = c("4WD Vehicles", "Front-Wheel Drive", "Rear-Wheel Drive"),
      x = c(6, 6, 6),
      y = c(40, 40, 40)
    )

    # Plot with different labels in each facet by adding a layer to the plot
    plot +
      geom_text(data = label_data, aes(x = x, y = y, label = label), color = "blue")

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-47-1.png)

**4. What arguments to geom\_label() control the appearance of the
background box?**

The arguments `fill=` and `color=` control primarily the basic
appearance of the background box. Other arguments handle stylistic
presentation: `label.padding=` controls padding; `label.r=` controls
rounding of corners; and `label.size=` controls border size of the
label.

**5. What are the four arguments to arrow()? How do they work? Create a
series of plots that demonstrate the most important options.**

`angle`: The angle of the arrow head in degrees (smaller numbers produce
narrower, pointier arrows). Essentially describes the width of the arrow
head.

`length`: A unit specifying the length of the arrow head (from tip to
base).

`ends`: One of “last”, “first”, or “both”, indicating which ends of the
line to draw arrow heads.

`type`: One of “open” or “closed” indicating whether the arrow head
should be a closed triangle.

    library(patchwork)

    # Base plot
    p <- ggplot(mpg, aes(x = displ, y = hwy)) +
      geom_point() +
      theme_minimal()

    # 1. Demonstrating the angle of the arrowhead
    p1 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(angle = 15), color = "red") +
      labs(title = "Arrow with angle = 15 degrees")

    p2 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(angle = 45), color = "blue") +
      labs(title = "Arrow with angle = 45 degrees")

    # 2. Demonstrating the length of the arrowhead
    p3 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(length = grid::unit(0.1, "inches")), color = "green") +
      labs(title = "Arrow with length = 0.1 inches")

    p4 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(length = grid::unit(0.5, "inches")), color = "purple") +
      labs(title = "Arrow with length = 0.5 inches")

    # 3. Demonstrating the ends of the arrow
    p5 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(ends = "first"), color = "orange") +
      labs(title = "Arrow on the first end")

    p6 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(ends = "both"), color = "brown") +
      labs(title = "Arrows on both ends")

    # 4. Demonstrating the type of the arrowhead
    p7 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(type = "open"), color = "black") +
      labs(title = "Arrow with open type")

    p8 <- p +
      annotate("segment", x = 2, y = 30, xend = 4, yend = 40,
               arrow = arrow(type = "closed"), color = "darkred") +
      labs(title = "Arrow with closed type")

    # Combine the plots using patchwork
    (p1 | p2) / (p3 | p4) / (p5 | p6) / (p7 | p8)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-48-1.png)

## 11.4.6 Exercises

**1. Why doesn’t the following code override the default scale?**

Left is the original code. This doesn’t work, because `geom_hex()`
doesn’t use color, it uses fill. The code on the right fixes this error.

    df <- tibble(
      x = rnorm(10000),
      y = rnorm(10000)
    )

    p1 <- ggplot(df, aes(x, y)) +
      geom_hex() +
      scale_color_gradient(low = "white", high = "red") +
      coord_fixed()

    p2 <- ggplot(df, aes(x, y)) +
      geom_hex() +
      scale_fill_gradient(low = "white", high = "red") +
      coord_fixed()

    (p1 | p2)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-49-1.png)

**2. What is the first argument to every scale? How does it compare to
labs()?**

The first argument is always the aesthetic the scale applies to: fill,
color, etc. `labs()` isn’t really comparable here, so I’m unsure why
this is asked: `labs()` performs text manipulations to text labels
associated with the plot; `scale_*()` modifies the (\*) aesthetic
properties.

**3. Change the display of the presidential terms by: Combining the two
variants that customize colors and x axis breaks; Improving the display
of the y axis; Labelling each term with the name of the president;
Adding informative plot labels; Placing breaks every 4 years (this is
trickier than it seems!).**

    presidential |>
      mutate(id = 33 + row_number()) |>
      ggplot(aes(x = start, y = id, color = party)) +
      geom_point() +
      geom_segment(aes(xend = end, yend = id)) +
      scale_color_manual(values = c(Republican = "#E81B23", Democratic = "#00AEF3")) +
      scale_x_date(
        breaks = seq(ymd("1930-01-01"), ymd("2024-01-01"), by = "4 years"),
        date_labels = "%y"
      ) +
      scale_y_continuous(
        breaks = 33 + seq_len(nrow(presidential)),
        labels = presidential$name
      ) +
      labs(
        title = "Timeline of U.S. Presidents by Party Affiliation",
        x = "Term Start Year",
        y = "President",
        color = "Political Party"
      )

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-50-1.png)

**4. First, create the following plot. Then, modify the code using
override.aes to make the legend easier to see.**

Creating the plot:

    ggplot(diamonds, aes(x = carat, y = price)) +
      geom_point(aes(color = cut), alpha = 1/20)

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-51-1.png)

Updated code:

    ggplot(diamonds, aes(x = carat, y = price)) +
      geom_point(aes(color = cut), alpha = 1/20) +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 3)))

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-52-1.png)

## 11.5.1 Exercises

**1. Pck a theme offered by the ggthemes() package and apply it to the
last plot you made.**

    library(ggthemes)

    ggplot(diamonds, aes(x = carat, y = price)) +
      geom_point(aes(color = cut), alpha = 1/20) +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 3))) +
      theme_economist()

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-53-1.png)

**2. Make the axis labels of your plot blue and bolded.**

    ggplot(diamonds, aes(x = carat, y = price)) +
      geom_point(aes(color = cut), alpha = 1/20) +
      guides(color = guide_legend(override.aes = list(alpha = 1, size = 3))) +
      theme_economist() +
      theme(
        axis.title = element_text(color = "blue", face = "bold")
      )

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-54-1.png)

## 11.6.1 Exercises

**1. What happens if you omit the parentheses in the following plot
layout. Can you explain why this happens?**

Parentheses omitted…

    p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
      geom_point() + 
      labs(title = "Plot 1")
    p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
      geom_boxplot() + 
      labs(title = "Plot 2")
    p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
      geom_point() + 
      labs(title = "Plot 3")

    p1 | p2 / p3

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-55-1.png)

**2. Using the three plots from the previous exercise, recreate the
following patchwork.**

    p1 <- ggplot(mpg, aes(x = displ, y = hwy)) + 
      geom_point() + 
      labs(title = "Plot 1")
    p2 <- ggplot(mpg, aes(x = drv, y = hwy)) + 
      geom_boxplot() + 
      labs(title = "Plot 2")
    p3 <- ggplot(mpg, aes(x = cty, y = hwy)) + 
      geom_point() + 
      labs(title = "Plot 3")

    p1 / (p2 | p3) +
      plot_annotation(tag_levels = 'A', tag_prefix = 'Fig. ', tag_suffix = ':')

![](2---RDS_Visualize_Exercises_files/figure-markdown_strict/unnamed-chunk-56-1.png)
