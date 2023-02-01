FROM centos:centos6
RUN curl -f -sL https://rpm.nodesource.com/setup_12.x | bash -
RUN yum install -y nodejs && rm -rf /var/cache/yum#
# Define working directory.
COPY . /src
WORKDIR /src
RUN npm install && npm cache clean --force;

EXPOSE 3000 8020
# Define default command.
CMD ["node", "server.js"]
