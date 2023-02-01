FROM rocker/r-devel-san

RUN apt-get -qq update \
	&& apt-get -qq dist-upgrade -y \
	&& apt-get -qq --no-install-recommends install git unixodbc unixodbc-dev postgresql-9.5 odbc-postgresql libssl-dev sudo -y && rm -rf /var/lib/apt/lists/*;

# Add postgres backends
RUN DEBIAN_FRONTEND=noninteractive apt-get update -qqy \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qqy install gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;

RUN DEBIAN_FRONTEND=noninteractive apt-get update -qqy \
 && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -qqy install \
        g++-5 \
        git \
        libmyodbc \
        libsqliteodbc \
        make \
        mysql-client \
        mysql-server \
        sqlite3 \
        unixodbc \
        unixodbc-dev \
        vim && rm -rf /var/lib/apt/lists/*;

RUN RD -e 'install.packages(c("devtools", "roxygen2", "testthat"), quiet = T)'
RUN RD -e 'devtools::install_github("hadley/odbc@nanodbc", dep = TRUE)'

ENV CXX g++-5
ENV ODBCSYSINI=/opt/odbc/.github/odbc
