FROM node:latest

# install yarn
RUN curl -f -o- -L https://yarnpkg.com/install.sh | bash

# install python tooling
RUN apt-get update -y && apt-get install --no-install-recommends -y python-dev python-pip && pip install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

# install other utils
RUN apt-get update -y && apt-get install --no-install-recommends -y screen && rm -rf /var/lib/apt/lists/*;

# install aws-cli
RUN pip install --no-cache-dir awscli
