FROM node:10.22.1-buster-slim

# Install aws cli
RUN apt-get update && apt-get install --no-install-recommends -y \
  git \
  groff \
  less \
  make \
  python-pip \
  zip \
  && rm -rf /var/lib/apt/lists/* \
  && pip install --no-cache-dir --upgrade pip \
  && pip install --no-cache-dir --upgrade awscli==1.14.5 s3cmd==2.0.1 python-magic

# Install code climate reporter
RUN curl -f -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./cc-test-reporter \
  && chmod +x ./cc-test-reporter
