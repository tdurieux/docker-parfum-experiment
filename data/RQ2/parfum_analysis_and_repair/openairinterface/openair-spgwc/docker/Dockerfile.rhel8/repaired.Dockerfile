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
#   Valid for RHEL8
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# BUILDER IMAGE
#---------------------------------------------------------------------
FROM registry.access.redhat.com/ubi8/ubi:latest as oai-spgwc-builder

# Entitlements and RHSM configurations are Open-Shift Secret and ConfigMaps
# It is pre-requisite
# Copy the entitlements
COPY ./etc-pki-entitlement /etc/pki/entitlement

# Copy the subscription manager configurations
COPY ./rhsm-conf /etc/rhsm
COPY ./rhsm-ca /etc/rhsm/ca

RUN rm /etc/rhsm-host && \
    # Initialize /etc/yum.repos.d/redhat.repo
    # See https://access.redhat.com/solutions/1443553
    yum repolist --disablerepo=* && \
    subscription-manager repos --enable codeready-builder-for-rhel-8-x86_64-rpms && \
    yum update -y && \
    yum -y install --enablerepo="codeready-builder-for-rhel-8-x86_64-rpms" \
       # diff, cmp and file are not in the ubi???
       diffutils \
       file \
       psmisc \
       git && rm -rf /var/cache/yum

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
FROM registry.access.redhat.com/ubi8/ubi:latest as oai-spgwc
ENV TZ=Europe/Paris
# We install some debug tools for the moment in addition of mandatory libraries
RUN yum update -y && \
    yum -y install --enablerepo="ubi-8-codeready-builder" \
      tzdata \
      procps-ng \
      psmisc \
      net-tools \
      libevent \
  && yum clean all -y \
  && rm -rf /var/cache/yum

# Copying executable and generated libraries
WORKDIR /openair-spgwc/bin
COPY --from=oai-spgwc-builder \
    /openair-spgwc/build/spgw_c/build/oai_spgwc \
    /openair-spgwc/scripts/entrypoint.sh \
    ./

# Copying installed libraries from builder
COPY --from=oai-spgwc-builder \
    /lib64/libgflags.so.2.1 \
    /lib64/libglog.so.0 \
    /lib64/libdouble-conversion.so.1 \
    /lib64/libconfig++.so.9 \
    /lib64/libboost_system.so.1.66.0 \
    /usr/local/lib64/libpistache.so.0 \
    /lib64/
RUN ldconfig

# Copying template configuration files
# The configuration folder will be flat
WORKDIR /openair-spgwc/etc
COPY --from=oai-spgwc-builder /openair-spgwc/etc/spgw_c.json .

WORKDIR /openair-spgwc

# expose ports
EXPOSE 2123/udp 8805/udp

CMD ["/openair-spgwc/bin/oai_spgwc", "-c", "/openair-spgwc/etc/spgw_c.json", "-o"]
ENTRYPOINT ["/openair-spgwc/bin/entrypoint.sh"]
