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

# `Z_VERSION` will be updated by `dev/change_zeppelin_version.sh`
ENV Z_VERSION="0.8.0"
ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" \
    Z_HOME="/zeppelin" \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8

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
RUN echo "$LOG_TAG Install miniconda2 related packages" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    git mercurial subversion && \
    echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.3.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && rm -rf /var/lib/apt/lists/*;
ENV PATH /opt/conda/bin:$PATH

RUN echo "$LOG_TAG Install python related packages" && \
    apt-get -y update && \
    apt-get install --no-install-recommends -y python-dev python-pip && \
    apt-get install --no-install-recommends -y gfortran && \
    # numerical/algebra packages
    apt-get install --no-install-recommends -y libblas-dev libatlas-dev liblapack-dev && \
    # font, image for matplotlib
    apt-get install --no-install-recommends -y libpng-dev libfreetype6-dev libxft-dev && \
    # for tkinter
    apt-get install --no-install-recommends -y python-tk libxml2-dev libxslt-dev zlib1g-dev && \
    pip install --no-cache-dir numpy && \
    pip install --no-cache-dir matplotlib && rm -rf /var/lib/apt/lists/*;

# Install Python packages
RUN echo "$LOG_TAG Install Python packages" && \
	apt-get -y --no-install-recommends install python3-pip && \
	python3 -m pip install pandas && \
	python3 -m pip install scipy && \
	python3 -m pip install sklearn && \
	python3 -m pip install matplotlib && \
	apt-get install -y --no-install-recommends python3-tk && \
	python3 -m pip install xgboost && rm -rf /var/lib/apt/lists/*;

# Create the notebook user and group
RUN groupadd -r notebook -g 433 && useradd -u 431 -r -g notebook -d /opt/notebook -s /sbin/nologin -c "Notebook user" notebook

# OCP anonymous user
RUN chgrp root /etc/passwd && chmod ug+rw /etc/passwd

COPY zeppelin-${Z_VERSION}.tar.gz /tmp

RUN echo "$LOG_TAG Download Zeppelin binary" && \    
    tar -zxvf /tmp/zeppelin-${Z_VERSION}.tar.gz && \
    rm -rf /tmp/zeppelin-${Z_VERSION}.tar.gz && \
    mv /zeppelin-${Z_VERSION} ${Z_HOME} && \
    chmod -R 777 ${Z_HOME} && \
    chown -R notebook:notebook ${Z_HOME}

RUN echo "$LOG_TAG Cleanup" && \
    apt-get autoclean && \
    apt-get clean   

USER notebook

COPY shiro.ini ${Z_HOME}/conf/
COPY zeppelin-site.xml ${Z_HOME}/conf/
COPY *.jar ${Z_HOME}/interpreter/onesaitplatform/ 
COPY zeppelin.sh ${Z_HOME}/bin/

EXPOSE 8080

ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR ${Z_HOME}
CMD ["bin/zeppelin.sh"]