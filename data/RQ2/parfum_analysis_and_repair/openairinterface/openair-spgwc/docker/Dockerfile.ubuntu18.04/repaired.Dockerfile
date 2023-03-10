#/*
# * Licensed to the OpenAirInterface (OAI) Software Alliance under one or more
# * contributor license agreements.  See the NOTICE file distributed with
# * this work for additional information regarding copyright ownership.
# * The OpenAirInterface Software Alliance licenses this file to You under
# * the OAI Public License, Version 1.1  (the "License"); you may not use this file
# * except in compliance with the License.
# * You may obtain a copy of the License at
# *
# *      http://www.openairinterface.org/?page_id=698
# *
# * Unless required by applicable law or agreed to in writing, software
# * distributed under the License is distributed on an "AS IS" BASIS,
# * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# * See the License for the specific language governing permissions and
# * limitations under the License.
# *-------------------------------------------------------------------------------
# * For more information about the OpenAirInterface (OAI) Software Alliance:
# *      contact@openairinterface.org
# */
#---------------------------------------------------------------------
#
# Dockerfile for the Open-Air-Interface SPGW-C service
#   Valid for Ubuntu-18.04 (bionic)
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# BUILDER IMAGE
#---------------------------------------------------------------------
FROM ubuntu:bionic as oai-spgwc-builder

ARG EURECOM_PROXY

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes \
      psmisc \
      software-properties-common \
      git && rm -rf /var/lib/apt/lists/*;

# Some GIT configuration command quite useful
RUN /bin/bash -c "if [[ -v EURECOM_PROXY ]]; then git config --global http.proxy $EURECOM_PROXY; fi"
RUN git config --global https.postBuffer 123289600
RUN git config --global http.sslverify false

# Copy the workspace as is
WORKDIR /openair-spgwc
COPY . /openair-spgwc

# Installing and Building SPGW-C
WORKDIR /openair-spgwc/build/scripts
RUN ./build_spgwc --install-deps --force
RUN ./build_spgwc --clean --build-type Release --jobs --Verbose && \
    mv /openair-spgwc/build/spgw_c/build/spgwc /openair-spgwc/build/spgw_c/build/oai_spgwc

#---------------------------------------------------------------------
# TARGET IMAGE
#---------------------------------------------------------------------
FROM ubuntu:bionic as oai-spgwc
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris
# We install some debug tools for the moment in addition of mandatory libraries
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get upgrade --yes && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install --yes \
      psmisc \
      tzdata \
      net-tools \
      tshark \
      perl \
      libgoogle-glog0v5 \
      libdouble-conversion1 \
      libconfig++9v5 && \
    rm -rf /var/lib/apt/lists/*

# Copying executable and generated libraries
WORKDIR /openair-spgwc/bin
COPY --from=oai-spgwc-builder \
    /openair-spgwc/build/spgw_c/build/oai_spgwc \
    /openair-spgwc/scripts/entrypoint.sh \
    ./

WORKDIR /usr/local/lib
COPY --from=oai-spgwc-builder \
    /usr/local/lib/libpistache.so.0 \
    /usr/lib/libboost_system.so.1.67.0 \
    ./
RUN ldconfig

# Copying template configuration files
# The configuration folder will be flat
WORKDIR /openair-spgwc/etc
COPY --from=oai-spgwc-builder /openair-spgwc/etc/spgw_c.json .

WORKDIR /openair-spgwc

# use this label for CI purpose
LABEL use-json-file="true"
LABEL support-multi-sgwu-instances="true"

# expose ports
EXPOSE 2123/udp 8805/udp

CMD ["/openair-spgwc/bin/oai_spgwc", "-c", "/openair-spgwc/etc/spgw_c.json", "-o"]
ENTRYPOINT ["/openair-spgwc/bin/entrypoint.sh"]
