FROM python:3.9.1-slim-buster
USER root

# PSQL Requirements
RUN apt-get update && apt-get install --no-install-recommends -y libpq-dev build-essential && rm -rf /var/lib/apt/lists/*;

# Get R
RUN apt-get -y --no-install-recommends install libssl-dev libgit2-dev libcurl4-gnutls-dev libxml2-dev openssl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install dirmngr --install-recommends && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
RUN add-apt-repository 'deb http://cloud.r-project.org/bin/linux/debian buster-cran40/'
RUN apt-get update
RUN apt-get -y --no-install-recommends install r-base && rm -rf /var/lib/apt/lists/*;

# Install R dependencies
RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'install.packages("tidyverse")'
RUN Rscript -e 'install.packages("doParallel")'
RUN Rscript -e 'install.packages("tidymodels")'
RUN Rscript -e 'install.packages("ranger")'
RUN Rscript -e 'install.packages("RPostgres")'

# Python Requirements
ADD requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Airflow Env Vars
ENV AIRFLOW_HOME='/usr/local/airflow'

# Set wd
WORKDIR /usr/local/airflow

# Sleep forever
CMD sleep infinity
