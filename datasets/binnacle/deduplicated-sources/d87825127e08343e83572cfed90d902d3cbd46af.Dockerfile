FROM perfectlysoft/perfectassistant:4.1

# Perfect-COpenSSL-Linux.git--493483816737093971/PADockerfile
RUN apt-get -y update && apt-get install -y libssl-dev

# Perfect-libcurl.git--5328870182550398275/PADockerfile
RUN apt-get -y update && apt-get install -y libcurl4-openssl-dev

# Perfect-mysqlclient-Linux.git-1407668322570047276/PADockerfile
RUN apt-get -y update && apt-get install -y libmysqlclient-dev
RUN sed -i -e 's/-fabi-version=2 -fno-omit-frame-pointer//g' /usr/lib/x86_64-linux-gnu/pkgconfig/mysqlclient.pc

# Perfect-LinuxBridge.git-7561928420558778701/PADockerfile
RUN apt-get -y update && apt-get install -y uuid-dev
RUN rm -rf /var/lib/apt/lists/*

# imagemagick for creating raid images
RUN apt-get -y update && apt-get install  -y imagemagick
RUN cp /usr/bin/convert /usr/local/bin
