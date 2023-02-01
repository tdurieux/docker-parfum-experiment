FROM ubuntu:18.04


ARG DEBIAN_FRONTEND=noninteractive
ARG R_VERSION
ARG CRAN_REPO

RUN apt-get update && \
    apt-get install --no-install-recommends -y dirmngr software-properties-common && \
    gpg --batch --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9 && \
    gpg --batch -a --export E298A3A825C0D65DFD57CBB651716619E084DAB9 | apt-key add - && rm -rf /var/lib/apt/lists/*;

RUN add-apt-repository -y "deb https://cloud.r-project.org/bin/linux/ubuntu $CRAN_REPO/"

RUN apt-get -y update && \
    apt-get -y install --no-install-recommends locales && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 && \
    apt-get -y clean && \
    apt-get -y autoremove && rm -rf /var/lib/apt/lists/*;

ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

RUN add-apt-repository -y ppa:deadsnakes/ppa
RUN apt-get update && \
    apt-get install -y --no-install-recommends "r-base-core=$R_VERSION" "r-base-dev=$R_VERSION" curl \
                        libcurl4-openssl-dev libssl-dev \
                        libssh2-1-dev libxml2-dev zlib1g-dev unixodbc-dev && \
                        apt-get -y clean && apt-get -y autoremove && rm -rf /var/lib/apt/lists/*;
RUN Rscript -e 'install.packages("testthat")'
RUN  Rscript -e 'install.packages("devtools", dependencies = TRUE)'
RUN  Rscript -e 'install.packages("remotes")'
RUN  Rscript -e 'library(remotes);install_version("RODBC","1.3-16")'
RUN  Rscript -e 'devtools::install_github("jimhester/covr")'
RUN  Rscript -e 'devtools::install_github("jimhester/lintr")'
RUN  Rscript -e 'devtools::install_github("marcelboldt/DBI")'
RUN  Rscript -e 'devtools::install_github("marcelboldt/DBItest")'

RUN curl -f -L -o EXASOL_ODBC.tar.gz https://www.exasol.com/support/secure/attachment/119101/EXASOL_ODBC-7.0.4.tar.gz && \
    mkdir -p /opt/exasol && \
    tar -xzf EXASOL_ODBC.tar.gz -C /opt/exasol --strip-components 1 && \
    touch /etc/odbcinst.ini && \
    echo "[EXASolution Driver]" >> /etc/odbcinst.ini && \
    echo "Driver=/opt/exasol/lib/linux/x86_64/libexaodbc-uo2214lv2.so" >> /etc/odbcinst.ini && rm EXASOL_ODBC.tar.gz

COPY run_test_within_docker.sh /run_test_within_docker.sh

ENTRYPOINT ["/run_test_within_docker.sh"]