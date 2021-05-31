# qdrmapbox

A minimal R package to download Mapbox raster tiles and georeference for static mapping

I wrote this R package for a [SESYNC Cyberhelp blog post][blog].

## Setup

Install the package using this command:

```
remotes::install_github('qdread/qdrmapbox')
```

To use this package, you will need to [sign up for a Mapbox account](https://account.mapbox.com/auth/signup/). Once you have an account, you will also need to [create an access token](https://account.mapbox.com/access-tokens/create). Access to the API is free up to a limit. For more details please see the [blog post][blog].

## Example walkthrough

A walkthrough of downloading and georeferencing tiles, and creating a map with the resulting image, is in the [blog post][blog]. Code for the walkthrough is in this repo (walkthrough.R).

*Last modified by QDR, 31 May 2021*

[blog]: https://cyberhelp.sesync.org/blog/mapping-with-Mapbox.html
