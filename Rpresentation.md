<style>
.code1 {
    color: black;
    top: 10%;
    text-align:left;
    width:100%;
    font-size: 20em;
    position: relative;
}

 h2 { 
   color: #559b6a; 
 } 

body { 

font-family: 'Helvetica';
   background: -webkit-linear-gradient(#356595,#4A5B63); /* For Safari 5.1 to 6.0 */ 
   background: -o-linear-gradient(#356595,#4A5B63); /* For Opera 11.1 to 12.0 */ 
   background: -moz-linear-gradient(#356595,#4A5B63); /* For Firefox 3.6 to 15 */
background: linear-gradient(#356595,#4A5B63); /* Standard syntax */ } 

font-family: 'Helvetica'
</style>


========================================================
transition: rotate
width: 1440
height: 900
# <h2>Time series - Exploratory data analysis</h2>


<h3>author: dt-scientist</h3>
<h3>date: 26-Oct-2014</h3>


Introduction
========================================================
class: code1

This aplication allows you to download and tranform historical data for a specific stock, plot it and add linear and non-linear smooths. Data is sourced from Yahoo finance

Transformations
========================================================

In data analysis transformation is the replacement of a variable by a
function of that variable: for example replacing a stock's Closing price (Close) by the square root of Close or the logarithm of Close. In a stronger sense, a transformation is a replacement that changes the shape of a distribution or relationship.

Types of transformations:
- linear regression
- locally weighted regression
- second-degree polynomial
- fifth-degree polynomial
- generalized additive model

Smooths
========================================================

Although points and lines of raw data can be helpful for exploring and understanding data, it can be difficult to tell what the overall trend or patterns are. Adding smooths can make it much easier to see. 

Types of smooths: 
- linear regression
- locally weighted regression
- second-degree polynomial
- fifth-degree polynomial
- generalized additive model
- linear filter

Example: Slide With Code
========================================================
Next's page code chunk returns the Closing price for Barclays (symbol:BARC.L) stock between 26-Oct-2012 and today's date and renders a plot as an image.The green line represents the Closing price while the red line represents the 40 period linear filter (moving average). Smoothing can used to reduce irregularities (random fluctuations) in the time series and provide a clearer view of the true underlying behaviour of the series.


```r
library(quantmod)
data <- getSymbols(Symbols="BARC.L", src = "yahoo", from =as.character('2012-10-26'),to = as.character(Sys.Date()),auto.assign = FALSE)
    chartSeries(data, theme = chartTheme("white"), type = "line", TA = 'addSMA(n = 40, on = 1, with.col = Cl, overlay = TRUE, col = "brown")')
```

![plot of chunk unnamed-chunk-1](Rpresentation-figure/unnamed-chunk-1.png) 
