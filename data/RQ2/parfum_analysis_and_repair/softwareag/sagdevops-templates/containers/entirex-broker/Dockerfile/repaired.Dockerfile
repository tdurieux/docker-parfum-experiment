###############################################################################
#  Copyright © 2013 - 2018 Software AG, Darmstadt, Germany and/or its licensors
#
#   SPDX-License-Identifier: Apache-2.0
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.                                                            
#
###############################################################################

ARG BUILDER_IMAGE
ARG BASE_IMAGE

FROM $BUILDER_IMAGE as builder

ARG TEMPLATE=sag-exx-broker

RUN $CC_HOME/provision.sh $TEMPLATE

FROM $BASE_IMAGE

# setting environment variables, can be overwritten during startup
ENV EXX_LICENSE_KEY=license.xml
ENV EXX_ATTRIBUTE=etbfile
ENV EXX_KEY_FILE=ExxAppKey.pem
ENV EXX_KEY_STORE=ExxAppCert.pem
ENV EXX_TRUST_STORE=ExxCACert.pem

# setting internal environment variables