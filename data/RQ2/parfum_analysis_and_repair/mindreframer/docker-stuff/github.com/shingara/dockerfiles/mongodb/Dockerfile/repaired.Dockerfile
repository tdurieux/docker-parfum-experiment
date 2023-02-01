FROM base
MAINTAINER Cyril Mougel "cyril.mougel@gmail.com"

# Avoid the init because no init in
RUN apt-get update && apt-get install --no-install-recommends -q -y wget && rm -rf /var/lib/apt/lists/*;
RUN wget https://downloads.mongodb.org/linux/mongodb-linux-x86_64-2.4.4.tgz -O mongodb.tgz
RUN tar xvzf mongodb.tgz && rm mongodb.tgz
RUN mv mongodb-linux-x86_64-2.4.4/bin/* /usr/bin/
RUN mkdir -p /data/db

# Cleanup useless data
RUN rm -rf mongodb-linux-x86_64-2.4.4*
RUN apt-get purge -q -y wget

