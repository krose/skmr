Intro
-----

This package is an R wrapper for the Syspower SKM API.

Install and load
----------------

Install the package from github.

    if(!require("devtools")) install.packages("devtools")
    library("devtools")
    install_github("krose/skm")

Load the package. I'll also load the ggplot2 package, to make fancier plots.

``` {.r}
library("skm")
```

Web Query data
--------------

### ENOQ4-14

Let's load the daily closing prices for the contract ENOQ4-14 in 2014.

``` {.r}
q414 <- skm_webquery(user_id = user_id, user_password = user_password, series_name = "NPENOQ414", interval = "day", start_time = "01-01-2014", end_time = "0")
str(q414)
```

    ## 'data.frame':    157 obs. of  2 variables:
    ##  $ Day      : POSIXct, format: "2014-01-02" "2014-01-03" ...
    ##  $ NPENOQ414: num  34.1 34.5 34.8 35.1 35.6 ...

### SPOT SYS and DK1 daily

Let's take a look at the SPOT for the system and DK1. Notice i query more than one series.

``` {.r}
spot <- skm_webquery(user_id = user_id, user_password = user_password, series_name = c("SPOT", "SPOTDK1"), interval = "day", start_time = "01-01-2014", end_time = "0")
str(spot)
```

    ## 'data.frame':    231 obs. of  3 variables:
    ##  $ Day    : POSIXct, format: "2014-01-01" "2014-01-02" ...
    ##  $ SPOT   : num  28.2 29.9 29.3 28 29.1 ...
    ##  $ SPOTDK1: num  21.9 23.1 27.1 22.3 26.8 ...

### SPOT SYS and DK1 hourly

And then there is hourly SPOT. Notice the start time.

``` {.r}
spot <- skm_webquery(user_id = user_id, user_password = user_password, series_name = c("SPOT", "SPOTDK1"), interval = "Hour", start_time = "w-2", end_time = "0")
str(spot)
```

    ## 'data.frame':    369 obs. of  3 variables:
    ##  $ Hour   : POSIXct, format: "2014-08-04 00:00:00" "2014-08-04 01:00:00" ...
    ##  $ SPOT   : num  29.3 29.1 28.7 28.5 28.7 ...
    ##  $ SPOTDK1: num  29.4 29.1 28.9 28.7 28.9 ...

UMM Query data
--------------

Here are just a few examples:

``` {.r}
## transmission

str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "week", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "transmission", areas = c("Sweden", "Denmark"), internalorfuels = "no"))
```

    ## 'data.frame':    5 obs. of  27 variables:
    ##  $ Date    : POSIXct, format: "2014-07-28" "2014-08-04" ...
    ##  $ DK1toSE3: num  545 630 658 487 520
    ##  $ SE3toDK1: num  680 623 623 480 567
    ##  $ DK2toSE4: num  1310 1624 1631 1370 1388
    ##  $ SE4toDK2: num  1300 1300 1283 1300 1300
    ##  $ NO1toSE3: num  2001 605 1027 980 1407
    ##  $ SE3toNO1: num  1606 646 1219 1159 1358
    ##  $ NO3toSE2: num  476 600 600 600 600
    ##  $ SE2toNO3: num  779 1000 952 864 906
    ##  $ NO4toSE1: num  650 620 575 656 559
    ##  $ SE1toNO4: num  450 450 450 533 365
    ##  $ NO4toSE2: num  150 150 126 215 203
    ##  $ SE2toNO4: num  250 250 223 257 253
    ##  $ FItoSE1 : num  974 677 1097 1139 1150
    ##  $ SE1toFI : num  1426 1295 1503 1461 1450
    ##  $ FItoSE3 : num  1200 1186 1200 1307 1350
    ##  $ SE3toFI : num  1200 1186 1200 1307 1350
    ##  $ DEtoSE4 : num  373 352 319 368 511
    ##  $ SE4toDE : num  477 516 313 441 610
    ##  $ PLtoSE4 : num  102 112 136 77 83
    ##  $ SE4toPL : num  435 431 431 551 500
    ##  $ DEtoDK1 : num  939 363 955 1437 1500
    ##  $ DK1toDE : num  223 323 18 1271 1780
    ##  $ NO2toDK1: num  944 535 808 529 612
    ##  $ DK1toNO2: num  994 710 974 816 850
    ##  $ DEtoDK2 : num  593 600 589 600 600
    ##  $ DK2toDE : num  578 585 575 585 585

``` {.r}
## production
str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "hour", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "production", areas = "Nordpool", internalorfuels = "Nuclear"))
```

    ## 'data.frame':    744 obs. of  2 variables:
    ##  $ Date             : POSIXct, format: "2014-08-01 00:00:00" "2014-08-01 01:00:00" ...
    ##  $ Nuclear(Nordpool): num  10168 10168 10168 10168 10168 ...

``` {.r}
## station
str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "day", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "station", areas = NULL, internalorfuels = 3))
```

    ## 'data.frame':    31 obs. of  3 variables:
    ##  $ Date   : POSIXct, format: "2014-08-01" "2014-08-02" ...
    ##  $ Alta G1: num  50 50 50 50 50 50 50 50 50 50 ...
    ##  $ Alta G2: num  110 110 110 110 110 110 110 110 110 110 ...
