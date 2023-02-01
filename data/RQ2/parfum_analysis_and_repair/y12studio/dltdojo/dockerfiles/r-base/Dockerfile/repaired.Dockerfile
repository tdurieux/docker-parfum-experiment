FROM r-base
RUN apt-get update && apt-get install --no-install-recommends -y curl jq libcurl4-gnutls-dev && rm -rf /var/lib/apt/lists/*;
RUN R -e 'install.packages("Rbitcoin", repos=c("https://jangorecki.gitlab.io/Rbitcoin","https://cran.rstudio.com"))'
ADD rbitcoin.R /
