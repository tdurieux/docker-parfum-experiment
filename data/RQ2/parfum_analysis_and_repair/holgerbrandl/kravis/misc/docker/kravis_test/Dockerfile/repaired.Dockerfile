FROM rocker/tidyverse:4.2.0

# svg-support we need cairo
RUN apt-get update && apt-get install --no-install-recommends --yes libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN R -e "install.packages('gdtools')"
RUN R -e "install.packages('svglite')"
RUN R -e "install.packages('pacman')"
RUN R -e "install.packages('plyr')"
