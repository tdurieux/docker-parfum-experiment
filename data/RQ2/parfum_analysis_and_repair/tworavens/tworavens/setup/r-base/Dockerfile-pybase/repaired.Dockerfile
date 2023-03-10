FROM python:3.6.8
MAINTAINER TwoRavens http://2ra.vn/

LABEL organization="Two Ravens" \
      2ra.vn.version="0.4-beta" \
      2ra.vn.release-date="2020-01-23" \
      description="Image for the base of the Two Ravens R service."

# ----------------------------------------------------
# This docker container runs "Flask-wrapped R",
# basically a flask server to run R scripts
# ----------------------------------------------------

# -------------------------------------
# Install debugging tools
# -------------------------------------
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils\
    iputils-ping \
    telnet \
    vim && rm -rf /var/lib/apt/lists/*;

# -------------------------------------
# Install Tex
# -------------------------------------
RUN apt-get -y --no-install-recommends install pandoc texlive-full && \
  tlmgr init-usertree && rm -rf /var/lib/apt/lists/*;

# -------------------------------------
# Install R 3.6 and needed packages for
#   preprocess, discovered problems, etc
# -------------------------------------
RUN apt-get -y --no-install-recommends install dirmngr --install-recommends && \
    apt-get -y --no-install-recommends install software-properties-common && \
    apt-get -y --no-install-recommends install apt-transport-https && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'

RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian stretch-cran35/'
#RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian buster-cran35/'

RUN apt-get update

RUN apt-get install --no-install-recommends -y r-base && rm -rf /var/lib/apt/lists/*;


# -------------------------------------
# Install R packages for preprocess,
#   discovered problems, etc
# -------------------------------------

# -------------------------------------
#   - Preprocess related R packages
# -------------------------------------
RUN R -e 'install.packages("DescTools", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("XML", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("jsonlite", repos="http://cran.rstudio.org")'

# -------------------------------------
#   - Other R packages (need to tease out usage)
# -------------------------------------
RUN R -e 'install.packages("VGAM", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("rpart", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("lubridate", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("data.table", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("stargazer", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("doParallel", repos="http://cran.rstudio.org")'

# -------------------------------------
#   - Report related R packages
# -------------------------------------
RUN R -e 'install.packages("rmarkdown", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("ggplot2", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("reshape2", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("grid", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("gridExtra", repos="http://cran.rstudio.org")' && \
    R -e 'install.packages("xtable", repos="http://cran.rstudio.org")'

# -------------------------------------
#   2020 additions
# -------------------------------------
RUN R -e 'install.packages("parsedate", repos="http://cran.rstudio.org")'



EXPOSE 8000

#
# docker build -t tworavens/r-service-base-py:latest -f Dockerfile-pybase .
#
# docker run -ti --rm --name r-base-test tworavens/r-service-base-py:latest /bin/bash
#




# -------------------------------------
# R older packages: don't appear to be used
# -------------------------------------
# possible non-use: packageList.none <- c('Amelia', "Rcpp" "dplyr", "devtools", "nloptr")
