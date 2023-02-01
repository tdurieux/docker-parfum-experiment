FROM rocker/tidyverse:3.5.1


# svg-support we need cairo
RUN apt-get update && apt-get install --no-install-recommends --yes libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN R -e "devtools::install_github('davidgohel/gdtools')"
RUN R -e "install.packages('svglite')"

#ENTRYPOINT R
