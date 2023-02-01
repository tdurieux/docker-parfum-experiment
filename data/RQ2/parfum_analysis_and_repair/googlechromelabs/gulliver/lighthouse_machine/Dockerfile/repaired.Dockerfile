#	Copyright 2016-2017, Google, Inc.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:latest

## PART 1: Core components
## =======================

# Install utilities
RUN apt-get update --fix-missing && apt-get -y upgrade && \
 apt-get install --no-install-recommends -y sudo apt-utils curl wget unzip git gnupg && rm -rf /var/lib/apt/lists/*;

# Install node 10
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
 sudo apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# Install Xvfb and dbus for X11
RUN apt-get install --no-install-recommends -y xvfb dbus-x11 && rm -rf /var/lib/apt/lists/*;

# Install Chrome for Ubuntu
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - &&\
sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' &&\
sudo apt-get update && \
 sudo apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# Install Yarn
RUN curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
sudo apt-get update && sudo apt-get install -y --no-install-recommends yarn && rm -rf /var/lib/apt/lists/*;

# Copy key documents (except .dockerignored files)
COPY etc/xvfb /etc/init.d/xvfb
RUN chmod +x /etc/init.d/xvfb

# Add a user and make it a sudo user
RUN useradd -m chromeuser

# Copy the chrome-user script used to start Chrome as non-root
COPY chromeuser-script.sh /
RUN chmod +x /chromeuser-script.sh

## PART 2: Lighthouse
## ==================

# Download lighthouse
RUN git clone https://github.com/googlechrome/lighthouse &&\
cd /lighthouse &&\
git checkout tags/v4.2.0 &&\
npm install -g yarn &&\
npm install -g yarnpkg &&\
npm install -g @types/mkdirp &&\
npm install -g --save-dev run-sequence &&\
npm install -g typescript &&\
npm install -g && \
yarn global add lighthouse && npm cache clean --force;

## PART 3: Express server
## ======================

# Install express
COPY package.json /
RUN npm install && npm cache clean --force;

# Add the simple server file
COPY server.js /
RUN chmod +x /server.js

# Add the cpu monitor file
COPY cpu_monitor.js /
RUN chmod +x /cpu_monitor.js

# Generate a self-signed SSL certificate
RUN openssl req \
  -new \
  -newkey rsa:4096 \
  -days 365 \
  -nodes \
  -x509 \
  -subj "/C=GB/ST=None/L=None/O=Google/CN=lighthouse-machine-X" \
  -keyout key.pem \
  -out cert.pem

# Expose ports 8080 and 8443
EXPOSE 8080
EXPOSE 8443

## PART 4: Final setup
## ===================

# Set the entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
