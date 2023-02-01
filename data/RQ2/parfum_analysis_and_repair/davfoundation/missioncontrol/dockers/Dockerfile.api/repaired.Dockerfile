FROM node:11

RUN apt-get update && \
  apt-get install --no-install-recommends -y python-pip bash-completion curl git nano wget make && rm -rf /var/lib/apt/lists/*;

RUN echo ". /usr/share/bash-completion/bash_completion" >> ~/.bashrc

RUN pip install --no-cache-dir cqlsh
RUN sed -i "s/^DEFAULT_CQLVER = '[0-9.]*'$/DEFAULT_CQLVER = '3.4.4'/" /usr/local/bin/cqlsh

RUN npm install -g nodemon && npm cache clean --force;

WORKDIR /app

COPY ./package.json /app/
RUN npm install && npm cache clean --force;

COPY . /app

CMD [ "npm", "start"]
EXPOSE 3005
