FROM node:12.19.0
LABEL AUTHOR=alexkim205

# Install other prerequisites
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  zip \
  unzip && rm -rf /var/lib/apt/lists/*;

# Install AWS CLI
RUN apt-get install --no-install-recommends -y \
  python3 \
  python3-pip \
  python3-setuptools \
  groff \
  less \
  && pip3 install --no-cache-dir --upgrade pip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN pip3 --no-cache-dir install --upgrade awscli

# Install Amplify CLI @latest
RUN npm install -g @aws-amplify/cli && npm cache clean --force;

# Install Cypress prerequisites
RUN apt-get update && \
  apt-get install --no-install-recommends -y \
  libgtk2.0-0 \
  libgtk-3-0 \
  libgbm-dev \
  libnotify-dev \
  libgconf-2-4 \
  libnss3 \
  libxss1 \
  libasound2 \
  libxtst6 \
  xauth \
  xvfb \
  firefox-esr && rm -rf /var/lib/apt/lists/*;

USER root