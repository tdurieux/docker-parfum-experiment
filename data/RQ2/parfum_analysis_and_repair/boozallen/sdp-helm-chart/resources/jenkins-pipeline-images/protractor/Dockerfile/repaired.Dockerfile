# Copyright © 2018 Booz Allen Hamilton. All Rights Reserved.
# This software package is licensed under the Booz Allen Public License. The license can be found in the License file or at http://boozallen.github.io/licenses/bapl

FROM java:openjdk-8-jdk

# install node
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN npm install -g protractor gulp jasmine-spec-reporter && \
    webdriver-manager update && \
    apt-get update && \
    apt-get install --no-install-recommends -y xvfb wget && \
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    dpkg --unpack google-chrome-stable_current_amd64.deb && \
    apt-get install -f -y && \
    apt-get clean && \
    rm google-chrome-stable_current_amd64.deb && npm cache clean --force; && rm -rf /var/lib/apt/lists/*;

# Install all npm packages from package.json
# RUN npm install

CMD /bin/bash
