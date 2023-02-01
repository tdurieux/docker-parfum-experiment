FROM node:10

RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install --no-install-recommends -y build-essential && \
  apt-get install --no-install-recommends -y software-properties-common && \
  apt-get install --no-install-recommends -y byobu curl git htop man unzip vim wget && rm -rf /var/lib/apt/lists/*;

RUN apt -y --no-install-recommends install default-jre && rm -rf /var/lib/apt/lists/*;

COPY ./vendors/firebase /

RUN npm install -g firebase-tools && npm cache clean --force;

ENTRYPOINT [ "firebase", "emulators:start" ]
