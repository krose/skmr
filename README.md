Intro
-----

This package is an R wrapper for the [Syspower SKM API](http://syspower.skm.no) and the developer version of this package and README can be found on [github.com/krose/skm](http://github.com/krose/skm)

This package is in early beta and it will most likely not have backward compatibility. Pull requests are accepted.

Install and load
----------------

Install the package from github.

    if(!require("devtools")) install.packages("devtools")
    library("devtools")
    install_github("krose/skm")

Load the package.

``` r
library("skm")
```

## Get token

SKM syspowers has made a new platform SYSPOWER5 where each user gets a token to use for webqueries. 
The new website is https://syspower5.skm.no. When entering this site for the first time you will have to follow these instructions:

•	Push «Get access to new SYSPOWER».
•	A new page will pop up and you fill in all your details in «User credentials request».
•	After filling in your «E-Mail» in the last line, push «Save» and an e-mail with your new password will be sent to you.
•	Use your e-mail and new password when you log in to the new platform SYSPOWER5.

When you have completed the above steps and have logged in to SYSPOWER5 then go to Webquery and you will find your token in the url between "Webquery url" and "Export data".

(UMM webquery update in progress)

Web Query data
--------------

### ENOQ4-14

Let's load the daily closing prices for the contract ENOQ4-14 in 2014.

``` r
q414 <- skm_webquery(token = token, series_name = "NPENOQ414", interval = "day", start_time = "01-01-2014", end_time = "0")
str(q414)
```

    ## 'data.frame':    188 obs. of  2 variables:
    ##  $ Day      : POSIXct, format: "2014-01-02" "2014-01-03" ...
    ##  $ NPENOQ414: num  34.1 34.5 34.8 35.1 35.6 ...

### SPOT SYS and DK1 daily

Let's take a look at the SPOT for the system and DK1. Notice i query more than one series.

``` r
spot <- skm_webquery(token = token, series_name = c("SPOT", "SPOTDK1"), interval = "day", start_time = "01-01-2014", end_time = "0")
str(spot)
```

    ## 'data.frame':    614 obs. of  3 variables:
    ##  $ Day    : POSIXct, format: "2014-01-01" "2014-01-02" ...
    ##  $ SPOT   : num  28.2 29.9 29.3 28 29.1 ...
    ##  $ SPOTDK1: num  21.9 23.1 27.1 22.3 26.8 ...

### SPOT SYS and DK1 hourly

And then there is hourly SPOT. Notice the start time.

``` r
spot <- skm_webquery(token = token, series_name = c("SPOT", "SPOTDK1"), interval = "Hour", start_time = "w-2", end_time = "0")
str(spot)
```

    ## 'data.frame':    499 obs. of  3 variables:
    ##  $ Hour   : POSIXct, format: "2015-08-17 00:00:00" "2015-08-17 01:00:00" ...
    ##  $ SPOT   : num  9.63 8.4 8.03 7.93 8.19 ...
    ##  $ SPOTDK1: num  9.61 8.38 8.01 7.92 8.12 ...

UMM Query data
--------------

Here are just a few examples:

``` r
## transmission

str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "week", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "transmission", areas = c("Sweden", "Denmark"), internalorfuels = "no"))
```

    ## 'data.frame':    5 obs. of  29 variables:
    ##  $ Date    : POSIXct, format: "2014-07-28" "2014-08-04" ...
    ##  $ DK1toSE3: num  545 630 658 487 568
    ##  $ SE3toDK1: num  680 623 623 480 680
    ##  $ DK2toSE4: num  1310 1624 1631 1365 1700
    ##  $ SE4toDK2: num  1300 1300 1283 1300 1300
    ##  $ NO1toSE3: num  2001 605 1027 926 1347
    ##  $ SE3toNO1: num  1606 646 1219 1137 1643
    ##  $ NO3toSE2: num  476 600 600 600 600
    ##  $ SE2toNO3: num  779 1000 952 862 952
    ##  $ NO4toSE1: num  650 620 575 630 533
    ##  $ SE1toNO4: num  450 450 450 450 367
    ##  $ NO4toSE2: num  150 150 126 167 150
    ##  $ SE2toNO4: num  250 250 223 233 238
    ##  $ FItoSE1 : num  974 677 1097 1107 1034
    ##  $ SE1toFI : num  1426 1295 1503 1493 1495
    ##  $ FItoSE3 : num  1200 1186 1200 1200 1200
    ##  $ SE3toFI : num  1200 1186 1200 1200 1200
    ##  $ DEtoSE4 : num  373 352 319 282 198
    ##  $ SE4toDE : num  477 516 313 298 571
    ##  $ PLtoSE4 : num  102 112 136 120 95
    ##  $ SE4toPL : num  435 431 431 427 408
    ##  $ LTtoSE4 : num  0 0 0 0 0
    ##  $ SE4toLT : num  0 0 0 0 0
    ##  $ DEtoDK1 : num  939 363 955 947 659
    ##  $ DK1toDE : num  223 323 18 0 576
    ##  $ NO2toDK1: num  944 535 808 600 781
    ##  $ DK1toNO2: num  994 710 974 801 850
    ##  $ DEtoDK2 : num  593 600 589 600 600
    ##  $ DK2toDE : num  578 585 575 585 585

``` r
## production
str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "hour", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "production", areas = "Nordpool", internalorfuels = "Nuclear"))
```

    ## 'data.frame':    744 obs. of  2 variables:
    ##  $ Date             : POSIXct, format: "2014-08-01 00:00:00" "2014-08-01 01:00:00" ...
    ##  $ Nuclear(Nordpool): num  12284 12284 12284 12284 12284 ...

``` r
## station
str(skm_ummquery(user_id = user_id, user_password = user_password, interval = "day", start_time = "2014-08-01", end_time = "2014-08-31", accrow = "no", type = "station", areas = NULL, internalorfuels = 3))
```

    ## 'data.frame':    31 obs. of  3 variables:
    ##  $ Date   : POSIXct, format: "2014-08-01" "2014-08-02" ...
    ##  $ Alta G1: num  50 50 50 50 50 50 50 50 50 50 ...
    ##  $ Alta G2: num  110 110 110 110 110 110 110 110 110 110 ...
