FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

COPY ext/01_nodoc /etc/dpkg/dpkg.cfg.d/01_nodoc

RUN apt-get -y update && \
    apt-get -y install \
        openjdk-11-jdk \
        locales \
        python3.8-venv \
        python3-pip \
        unixodbc \
        unixodbc-dev \
        curl \
        git && \
    locale-gen en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 && \
    apt-get -y clean && \
    apt-get -y autoremove && \
    ldconfig

RUN curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh

RUN mkdir -p downloads/ODBC downloads/JDBC downloads/EXAplus
RUN curl -s https://www.exasol.com/support/secure/attachment/65437/EXASOL_ODBC-6.0.11.tar.gz | tar -C downloads/ODBC --strip-components 1 -zxf -
RUN curl -s https://www.exasol.com/support/secure/attachment/60963/EXASOL_JDBC-6.0.8.tar.gz | tar -C downloads/JDBC --strip-components 1 -zxf -
RUN curl -s https://www.exasol.com/support/secure/attachment/63966/EXAplus-6.0.10.tar.gz | tar -C downloads/EXAplus --strip-components 1 -zxf -
ENV EXAPLUS=/downloads/EXAplus/exaplus

COPY requirements.txt requirements.txt
RUN pip3 install -r "requirements.txt"
