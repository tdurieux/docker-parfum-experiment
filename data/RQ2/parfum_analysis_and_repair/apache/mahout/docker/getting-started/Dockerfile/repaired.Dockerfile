# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04
MAINTAINER Apache Software Foundation <dev@zeppelin.apache.org>

ENV Z_VERSION="0.9.0-preview1"

ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    ZEPPELIN_ADDR="0.0.0.0"

RUN echo "$LOG_TAG update and install basic packages" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y locales && \
    locale-gen $LANG && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt -y autoclean && \
    apt -y dist-upgrade && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

RUN echo "$LOG_TAG install tini related packages" && \
    apt-get install --no-install-recommends -y wget curl grep sed dpkg && \
    TINI_VERSION=$( curl -f https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:') && \
    curl -f -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
    dpkg -i tini.deb && \
    rm tini.deb && rm -rf /var/lib/apt/lists/*;

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jdk && \
    rm -rf /var/lib/apt/lists/*

# should install conda first before numpy, matploylib since pip and python will be installed by conda
RUN echo "$LOG_TAG Install miniconda3 related packages" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && rm -rf /var/lib/apt/lists/*;

ENV PATH /opt/conda/bin:$PATH

RUN echo "$LOG_TAG Install python related packages" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y python-dev python-pip && \
    apt-get install --no-install-recommends -y gfortran && \
    # numerical/algebra packages
    apt-get install --no-install-recommends -y libblas-dev libatlas-dev liblapack-dev && \
    # font, image
    apt-get install --no-install-recommends -y libpng-dev libfreetype6-dev libxft-dev && \
    # for tkinter
    apt-get install --no-install-recommends -y python-tk libxml2-dev libxslt-dev zlib1g-dev && \
    hash -r && \
    conda config --set always_yes yes --set changeps1 no && \
    conda update -q conda && \
    conda info -a && \
    conda config --add channels conda-forge && \
    pip install --no-cache-dir -q pycodestyle==2.5.0 && \
    pip install --no-cache-dir -q numpy==1.17.3 pandas==0.25.0 scipy==1.3.1 grpcio==1.19.0 bkzep==0.6.1 hvplot==0.5.2 protobuf==3.10.0 pandasql==0.7.3 ipython==7.8.0 matplotlib==3.0.3 ipykernel==5.1.2 jupyter_client==5.3.4 bokeh==1.3.4 panel==0.6.0 holoviews==1.12.3 seaborn==0.9.0 plotnine==0.5.1 intake==0.5.3 intake-parquet==0.2.2 altair==3.2.0 pycodestyle==2.5.0 apache_beam==2.15.0 && rm -rf /var/lib/apt/lists/*;

RUN echo "$LOG_TAG Install R related packages" && \
    echo "PATH: $PATH" && \
    ls /opt/conda/bin && \
    echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9 && \
    apt-get -y update && \
    apt-get -y --no-install-recommends --allow-unauthenticated install r-base r-base-dev && \
    R -e "install.packages('evaluate', repos = 'https://cloud.r-project.org')" && \
    R -e "install.packages('knitr', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('ggplot2', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('googleVis', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('data.table', repos='http://cran.us.r-project.org')" && \
#    R -e "install.packages('IRkernel', repos = 'https://cloud.r-project.org');IRkernel::installspec()" && \
    R -e "install.packages('shiny', repos = 'https://cloud.r-project.org')" && \
    # for devtools, Rcpp
    apt-get -y --no-install-recommends install libcurl4-gnutls-dev libssl-dev && \
    R -e "install.packages('devtools', repos='http://cran.us.r-project.org')" && \
    R -e "install.packages('Rcpp', repos='http://cran.us.r-project.org')" && \
    Rscript -e "library('devtools'); library('Rcpp'); install_github('ramnathv/rCharts')" && rm -rf /var/lib/apt/lists/*;

RUN echo "$LOG_TAG Cleanup" && \
    apt-get autoclean && \
    apt-get clean

RUN echo "$LOG_TAG Download Zeppelin binary" && \
    wget --quiet -O /tmp/zeppelin-${Z_VERSION}-bin-all.tgz https://archive.apache.org/dist/zeppelin/zeppelin-${Z_VERSION}/zeppelin-${Z_VERSION}-bin-all.tgz && \
    tar -zxvf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    rm -rf /tmp/zeppelin-${Z_VERSION}-bin-all.tgz && \
    mkdir -p ${Z_HOME} && \
    mv /zeppelin-${Z_VERSION}-bin-all/* ${Z_HOME}/ && \
    chown -R root:root ${Z_HOME} && \
    mkdir -p ${Z_HOME}/logs ${Z_HOME}/run ${Z_HOME}/webapps && \
    # Allow process to edit /etc/passwd, to create a user entry for zeppelin
    chgrp root /etc/passwd && chmod ug+rw /etc/passwd && \
    # Give access to some specific folders
    chmod -R 775 "${Z_HOME}/logs" "${Z_HOME}/run" "${Z_HOME}/notebook" "${Z_HOME}/conf" && \
    # Allow process to create new folders (e.g. webapps)
    chmod 775 ${Z_HOME}

COPY log4j.properties ${Z_HOME}/conf/

RUN rm -rf /zeppelin/notebook/'Flink Tutorial'
RUN rm -rf /zeppelin/notebook/'Python Tutorial'
RUN rm -rf /zeppelin/notebook/'R Tutorial'
RUN rm -rf /zeppelin/notebook/'Spark Tutorial'
RUN rm -rf /zeppelin/notebook/'Zeppelin Tutorial'
ARG NOTEBOOK_NAME_WITH_SPACE="Using Mahout_2BYEZ5EVK.zpln"
ADD ./${NOTEBOOK_NAME_WITH_SPACE} /zeppelin/notebook/${NOTEBOOK_NAME_WITH_SPACE}
#
RUN apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/apache/mahout
WORKDIR /mahout
RUN git checkout 14.1
RUN mvn clean install -DskipTests

#include Mahout interpreter
USER 1000

ADD interpreter.json /zeppelin/conf/interpreter.json


EXPOSE 8080


ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]

