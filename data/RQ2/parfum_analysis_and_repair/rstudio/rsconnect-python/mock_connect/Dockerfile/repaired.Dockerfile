FROM python:3.7-alpine
MAINTAINER RStudio Connect <rsconnect@rstudio.com>

# Add the Python packags we need.
RUN pip install --no-cache-dir flask
