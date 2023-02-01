FROM skelebot/r-base
MAINTAINER Sean Shookman <sshookman@cars.com>

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y -q build-essential krb5-user libsasl2-dev libsasl2-modules-gssapi-mit && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libmariadbclient-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libpq-dev && rm -rf /var/lib/apt/lists/*;
RUN R CMD javareconf
RUN ["Rscript", "-e", "install.packages('rJava',repo='https://cloud.r-project.org');library(rJava)"]
RUN ["Rscript", "-e", "install.packages('RJDBC',repo='https://cloud.r-project.org');library(RJDBC)"]
RUN ["Rscript", "-e", "install.packages('implyr',repo='https://cloud.r-project.org');library(implyr)"]
RUN ["Rscript", "-e", "install.packages('data.table',repo='https://cloud.r-project.org');library(data.table)"]

RUN curl -f https://archive.cloudera.com/cdh5/cdh/5/hadoop-2.6.0-cdh5.13.3.tar.gz -o /etc/hadoop.tar.gz
RUN tar -xvzf /etc/hadoop.tar.gz && rm /etc/hadoop.tar.gz

COPY jars.zip /etc/CDH/
WORKDIR /etc/CDH/
RUN unzip jars.zip
WORKDIR /

COPY init.sh /krb/
RUN chmod +x /krb/init.sh
