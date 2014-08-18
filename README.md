Intro
-----

This package is an R wrapper for the Syspower SKM API.

Install and load
----------------

Install the package from github.

    if(!require("devtools")) install.packages("devtools")
    library("devtools")
    install_github("krose/dkstat")

Load the package. I'll also load the ggplot2 package, to make fancier plots.

``` {.r}
library("skm")
library("ggplot2")
```

Query data
----------

### ENOQ4-14

Let's load the daily closing prices for the contract ENOQ4-14 in 2014.

``` {.r}
q414 <- skm_webquery(user_id = user_id, user_password = user_password, series_name = "NPENOQ414", interval = "day", start_time = "01-01-2014", end_time = "0")
str(q414)
```

    ## 'data.frame':    157 obs. of  2 variables:
    ##  $ Day      : POSIXct, format: "2014-01-02" "2014-01-03" ...
    ##  $ NPENOQ414: num  34.1 34.5 34.8 35.1 35.6 ...

Now let's plot the data.

``` {.r}
plot <- ggplot(aes(x = Day, y = NPENOQ414), data = q414) + geom_line()
plot
```

![plot of chunk unnamed-chunk-3](./README_files/figure-markdown_github/unnamed-chunk-3.png)

### SPOT SYS and DK1 daily

Let's take a look at the SPOT for the system and DK1. Notice i query more than one series.

``` {.r}
spot <- skm_webquery(user_id = user_id, user_password = user_password, series_name = c("SPOT", "SPOTDK1"), interval = "day", start_time = "01-01-2014", end_time = "0")
str(spot)
```

    ## 'data.frame':    230 obs. of  3 variables:
    ##  $ Day    : POSIXct, format: "2014-01-01" "2014-01-02" ...
    ##  $ SPOT   : num  28.2 29.9 29.3 28 29.1 ...
    ##  $ SPOTDK1: num  21.9 23.1 27.1 22.3 26.8 ...

``` {.r}
plot <- ggplot(data = spot)
plot <- plot + geom_line(aes(x = Day, SPOT), col = "blue")
plot <- plot + geom_line(aes(x = Day, SPOTDK1), col = "black")
plot
```

![plot of chunk unnamed-chunk-4](./README_files/figure-markdown_github/unnamed-chunk-4.png)

### SPOT SYS and DK1 hourly

And then there is hourly SPOT.

``` {.r}
spot <- skm_webquery(user_id = user_id, user_password = user_password, series_name = c("SPOT", "SPOTDK1"), interval = "Hour", start_time = "01-01-2014", end_time = "0")
str(spot)
```

    ## 'data.frame':    5517 obs. of  3 variables:
    ##  $ Hour   : POSIXct, format: "2014-01-01 00:00:00" "2014-01-01 01:00:00" ...
    ##  $ SPOT   : num  28.5 28 27.2 26.1 25.2 ...
    ##  $ SPOTDK1: num  15.2 13 12.1 11.7 11.7 ...

``` {.r}
plot <- ggplot(data = spot)
plot <- plot + geom_line(aes(x = Hour, SPOT), col = "blue")
plot <- plot + geom_line(aes(x = Hour, SPOTDK1), col = "black")
plot
```

![plot of chunk unnamed-chunk-5](./README_files/figure-markdown_github/unnamed-chunk-5.png)
