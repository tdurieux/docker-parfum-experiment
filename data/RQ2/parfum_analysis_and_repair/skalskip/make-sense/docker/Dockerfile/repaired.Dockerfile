FROM node:14.18.0

RUN apt-get update && apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*

RUN mkdir /workspace && \
  cd /workspace && \ 
  git clone https://github.com/SkalskiP/make-sense.git && \
  cd make-sense && \
  npm install && npm cache clean --force;

WORKDIR /workspace/make-sense

ENTRYPOINT ["npm", "start"]
