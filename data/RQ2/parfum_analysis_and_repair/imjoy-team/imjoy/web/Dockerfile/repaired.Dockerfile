FROM node:8

RUN apt-get update && apt-get -y --no-install-recommends install bzip2 git && rm -rf /var/lib/apt/lists/*;
RUN npm install --quiet --global \
      vue-cli && npm cache clean --force;

RUN mkdir /code
# COPY . /code
# Add ./ /code/

WORKDIR /code
