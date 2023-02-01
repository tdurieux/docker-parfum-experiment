#
# 	Base Image
#
FROM debian:8.6

#
#	Basic Setup
#
MAINTAINER David Gatti

#
#	preparing the environment
#
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

#
#	Create app directory
#
RUN mkdir -p /home/app

#
#	Copy the content of the app
#
COPY . /home/app

#
#	Switch working directory
#
WORKDIR /home/app

#
#	Prepare the app by installing all the dependencies
#
RUN npm install && npm cache clean --force;

#
#	Run the app
#
CMD [ "npm", "start" ]