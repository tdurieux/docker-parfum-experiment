FROM node:16-stretch-slim
RUN apt-get update  &&  apt-get upgrade -y && apt-get install --no-install-recommends -y git build-essential python3 && rm -rf /var/lib/apt/lists/*;
RUN mkdir /src
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;
ARG viewer
ARG fork
RUN git clone https://github.com/${fork:-camicroscope}/camicroscope.git --branch=${viewer:-master}
EXPOSE 4010

RUN chgrp -R 0 /src && \
    chmod -R g+rwX /src

USER 1001

CMD node caracal.js
