# AWR.Redshift

This is an R client to interact with the [AWS Redshift](https://aws.amazon.com/athena) service, including wrapper functions 
around the [Redshift JDBC package](http://docs.aws.amazon.com/redshift/latest/gsg/getting-started.html).

## Installation

The package is not yet hosted on CRAN. 

But you can easily install the most recent development version of the R package as well:

```r
devtools::install_github('nfultz/AWR.Redshift')
```

## What is it good for?

This provides a simplified DBI driver for Redshift:

```r
#TODO
```

Installing and loading the JDBC driver package is handled automatically. 

## What if I want to do other cool things with Redshift and R?

Most database functionality is actually provided by RJDBC, but if you have Redshift-specific
features in mind, please open a ticket on the feature request, or even better, submit a pull request :)

## It doesn't work here!
TODO
