FROM ubuntu:14.04

RUN apt-get update

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y npm && rm -rf /var/lib/apt/lists/*;
RUN npm install -g forever && npm cache clean --force;

RUN ln -s /usr/bin/nodejs /usr/bin/node

RUN git clone https://github.com/uptownhr/dpanel.git
WORKDIR /dpanel
RUN npm install && npm cache clean --force;

RUN echo "forever start /dpanel/api.js" >> /etc/bash.bashrc


EXPOSE 9999