# In production this should probably be busybox, but let's use ubuntu for a
# fair comparison 
FROM rubioj/base

MAINTAINER Juan Rubio, rubioj@us.ibm.com

# Install the redis server and CLI tool
#RUN apt-get install -y redis-server
ADD pack.tar.gz /tmp/

# We want to ensure there is a directory to run the redis-server, and that it has a sane password