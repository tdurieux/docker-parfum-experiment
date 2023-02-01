#http://stackoverflow.com/questions/27701930/add-user-to-docker-container

# start with this image as a base
FROM node:5

RUN npm cache clean --force

RUN apt-get update && \
      apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;


RUN chmod -R 777 $(npm root -g)

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app

WORKDIR /usr/src/app

COPY . .

RUN sudo chmod -R 777 .

ENTRYPOINT ["/usr/src/app/default.sh"]

