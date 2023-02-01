FROM amazonlinux:2.0.20200722.0

# install dependencies
RUN yum -y install make gcc* && rm -rf /var/cache/yum
RUN curl -f --silent --location https://rpm.nodesource.com/setup_12.x | bash -
RUN yum -y install nodejs && rm -rf /var/cache/yum
RUN yum -y install zip && rm -rf /var/cache/yum

# create directories
RUN mkdir /app /build

# copy source code
COPY ./app/* /app/

# install npm dependencies
WORKDIR /app
RUN npm install && npm cache clean --force;

# build app
WORKDIR /app
RUN zip -r /build/build.zip .

# put container to sleep in order to copy the build
CMD sleep 10m
