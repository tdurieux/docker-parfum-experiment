FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y npm nodejs && rm -rf /var/lib/apt/lists/*;

RUN groupadd -r ubuntu && useradd -r -g ubuntu ubuntu && \
    mkdir /home/ubuntu && chown ubuntu:ubuntu /home/ubuntu

USER ubuntu
RUN mkdir -p /home/ubuntu/kanception
WORKDIR /home/ubuntu/kanception
COPY package*.json ./
RUN npm install && npm cache clean --force;

COPY --chown=ubuntu:ubuntu . /home/ubuntu/kanception

CMD ["npm", "run", "start"]

