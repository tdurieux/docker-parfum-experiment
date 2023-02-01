FROM r-base
RUN apt-get update
RUN apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmariadbclient-dev && rm -rf /var/lib/apt/lists/*;

RUN R -e 'install.packages("Rcpp", dependencies = TRUE)'
RUN R -e 'install.packages("ggplot2", dependencies = TRUE)'
RUN R -e 'install.packages("dplyr", dependencies = TRUE)'





