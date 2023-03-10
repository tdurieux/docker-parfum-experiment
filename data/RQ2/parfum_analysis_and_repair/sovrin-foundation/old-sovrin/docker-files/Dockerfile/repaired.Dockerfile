######################################################################################################################
#              -----------Follow the Below Steps to run the Docker File--------------                                #
#                                                                                                                    #
# Step-1: docker build -f <Dockerfile Name> .                                                                        #
# Step-2: docker run -it <Docker image ID>                                                                           #
# Step-3: vi /opt/orientdb/config/orientdb-server-config.xml                                                         #
# Add the following lines between the <users> and </users> tags.                                                     #
# <user name="sovrin" password="password" resources="*"/>                                                            #
# <user name="root" password="password" resources="*" />                                                             #
# Between the <storages> and </storages> tags, add:                                                                  #
# <storage path="memory:temp" name="temp" userName="sovrin" userPassword="password" loaded-at-startup="true" />      #
# Step-4: service orientdb start                                                                                     #
# Step-5: service orientdb status                                                                                    #
# Step-6: init_sovrin_raet_keep --name <sovrin node name>                                                            #
# Step-7: start_sovrin_node <sovrin node name> <port1> <port2>                                                       #
#                                                                                                                    #
######################################################################################################################
FROM ubuntu:latest
RUN apt-get -y update && apt-get -y upgrade && apt-get -y --no-install-recommends install vim wget software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:fkrull/deadsnakes
RUN apt-get update -y && apt-get install --no-install-recommends python3.5 -y && rm -rf /var/lib/apt/lists/*;
RUN echo "deb http://ppa.launchpad.net/chris-lea/libsodium/ubuntu trusty main" >> /etc/apt/sources.list && echo "deb-src http://ppa.launchpad.net/chris-lea/libsodium/ubuntu trusty main" >> /etc/apt/sources.list
RUN apt-get -y clean && apt-get -y update
RUN touch libsodium.key
COPY libsodium.key /libsodium.key
RUN apt-key add libsodium.key && apt-get update -y && apt-get install --no-install-recommends -y libsodium13 --allow-unauthenticated && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN useradd -m sovrin
RUN su - sovrin
RUN apt-get update -y && apt-get install --no-install-recommends software-properties-common -y && add-apt-repository ppa:webupd8team/java -y && apt-get update -y && rm -rf /var/lib/apt/lists/*;
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN apt-get install --no-install-recommends oracle-java8-installer -y --allow-unauthenticated && apt-get install --no-install-recommends oracle-java8-set-default -y --allow-unauthenticated && rm -rf /var/lib/apt/lists/*;
RUN wget https://orientdb.com/download.php?file=orientdb-community-2.2.8.tar.gz -O /tmp/orientdb.tar.gz
RUN mkdir /opt/orientdb && tar xzvf /tmp/orientdb.tar.gz --strip-components=1 -C /opt/orientdb && rm -r /tmp/orientdb.tar.gz
RUN sed -i 's/YOUR_ORIENTDB_INSTALLATION_PATH/\/opt\/orientdb/g' /opt/orientdb/bin/orientdb.sh
RUN sed -i 's/USER_YOU_WANT_ORIENTDB_RUN_WITH/sovrin/g' /opt/orientdb/bin/orientdb.sh
RUN chmod 640 /opt/orientdb/config/orientdb-server-config.xml
RUN chown -R sovrin /opt/orientdb && chgrp -R sovrin /opt/orientdb && chmod -R 744 /opt/orientdb/databases && chmod 755 /opt/orientdb/bin/*.sh
RUN ln -s /opt/orientdb/bin/orientdb.sh /etc/init.d/orientdb
RUN mkdir -p ~/.sovrin && touch ~/.sovrin/sovrin_config.py
COPY sovrin_config.py ~/.sovrin/sovrin_config.py
RUN service orientdb start
RUN apt-get update -y && apt-get install --no-install-recommends libgmp3-dev libssl-dev -y && rm -rf /var/lib/apt/lists/*;
RUN wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz && tar xvf pbc-0.5.14.tar.gz && rm pbc-0.5.14.tar.gz
RUN apt-get install --no-install-recommends flex bison -y && rm -rf /var/lib/apt/lists/*;
RUN cd pbc-0.5.14 && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install
RUN pip3 install --no-cache-dir --upgrade pip wheel setuptools
RUN pip3 install --no-cache-dir sovrin
RUN pip3 install --no-cache-dir sovrin-dev
RUN pip3 install -U --no-cache-dir sovrin-dev
