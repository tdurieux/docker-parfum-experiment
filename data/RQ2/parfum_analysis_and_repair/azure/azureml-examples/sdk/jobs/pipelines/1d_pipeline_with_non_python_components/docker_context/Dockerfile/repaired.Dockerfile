FROM rocker/tidyverse:4.0.0-ubuntu18.04

# Install python
RUN apt-get update -qq && \
 apt-get install --no-install-recommends -y python3-pip tcl tk libz-dev libpng-dev && rm -rf /var/lib/apt/lists/*;

RUN ln -f /usr/bin/python3 /usr/bin/python
RUN ln -f /usr/bin/pip3 /usr/bin/pip
RUN pip install --no-cache-dir -U pip

# Install azureml-mlflow
RUN pip install --no-cache-dir azureml-mlflow

# Create link for python
RUN ln -f /usr/bin/python3 /usr/bin/python

# Install additional R packages
RUN R -e "install.packages(c('mlflow'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('carrier'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('optparse'), repos = 'https://cloud.r-project.org/')"
RUN R -e "install.packages(c('tcltk2'), repos = 'https://cloud.r-project.org/')"