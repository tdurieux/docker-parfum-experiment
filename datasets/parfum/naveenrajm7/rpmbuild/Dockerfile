# Using CentOS 7 as base image to support rpmbuild (packages will be Dist el7)
FROM centos:7

# Copying all contents of rpmbuild repo inside container
COPY . .

# Installing tools needed for rpmbuild , 
# depends on BuildRequires field in specfile, (TODO: take as input & install)
RUN yum install -y rpm-build rpmdevtools gcc make coreutils python git

# Setting up node to run our JS file
# Download Node Linux binary
RUN curl -O https://nodejs.org/dist/v12.16.1/node-v12.16.1-linux-x64.tar.xz

# Extract and install
RUN tar --strip-components 1 -xvf node-v* -C /usr/local

# Install dependecies and build main.js
RUN npm install --production \
&& npm run-script build

# All remaining logic goes inside main.js , 
# where we have access to both tools of this container and 
# contents of git repo at /github/workspace
ENTRYPOINT ["node", "/lib/main.js"]
