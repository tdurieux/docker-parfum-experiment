# Copyright 2018 Amazon.com, Inc. or its affiliates. All Rights Reserved.
# Licensed under the Apache License, Version 2.0 (the "License").
# You may not use this file except in compliance with the License.
# A copy of the License is located at
#     http://www.apache.org/licenses/LICENSE-2.0
# or in the "license" file accompanying this file. This file is distributed
# on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
# express or implied. See the License for the specific language governing
# permissions and limitations under the License.
#

FROM awsdeeplearningteam/mms-build:python3.6@sha256:2c1afa8834907ceec641d254dffbf4bcc659ca2d00fd6f2872d7521f32c9fa2e

# 2020 - Updated Build and Test dependencies

# Python packages for MMS Server
RUN pip install --no-cache-dir psutil \
    && pip install --no-cache-dir future \
    && pip install --no-cache-dir Pillow \
    && pip install --no-cache-dir wheel \
    && pip install --no-cache-dir twine \
    && pip install --no-cache-dir requests \
    && pip install --no-cache-dir mock \
    && pip install --no-cache-dir numpy \
    && pip install --no-cache-dir Image \
    && pip install --no-cache-dir mxnet==1.5.0

# Python packages for pytests
RUN pip install --no-cache-dir pytest==4.0.0 \
    && pip install --no-cache-dir pytest-cov \
    && pip install --no-cache-dir pytest-mock

# Python packages for benchmark
RUN pip install --no-cache-dir pandas

# Install NodeJS and packages for API tests
RUN curl -f -sL https://deb.nodesource.com/setup_14.x | sudo -E bash - \
    && sudo apt-get install --no-install-recommends -y nodejs \
    && sudo npm install -g newman newman-reporter-html && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Install jmeter for benchmark
# ToDo: Remove --no-check-certificate; temporarily added to bypass jmeter-plugins.org's expired certificate
RUN cd /opt \
    && wget https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-5.3.tgz \
    && tar -xzf apache-jmeter-5.3.tgz \
    && cd apache-jmeter-5.3 \
    && ln -s /opt/apache-jmeter-5.3/bin/jmeter /usr/local/bin/jmeter \
    && wget --no-check-certificate https://jmeter-plugins.org/get/ -O lib/ext/jmeter-plugins-manager-1.4.jar \
    && wget https://search.maven.org/remotecontent?filepath=kg/apc/cmdrunner/2.2/cmdrunner-2.2.jar -O lib/cmdrunner-2.2.jar \
    && java -cp lib/ext/jmeter-plugins-manager-1.4.jar org.jmeterplugins.repository.PluginManagerCMDInstaller \
    && bin/PluginsManagerCMD.sh install jpgc-synthesis=2.1,jpgc-filterresults=2.1,jpgc-mergeresults=2.1,jpgc-cmd=2.1,jpgc-perfmon=2.1 && rm apache-jmeter-5.3.tgz