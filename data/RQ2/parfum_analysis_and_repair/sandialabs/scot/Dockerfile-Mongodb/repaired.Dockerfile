FROM mongo:3.4-xenial

# Create the MongoDB data directory
RUN mkdir -p /var/lib/mongodb 
RUN mkdir -p /var/log/mongodb

EXPOSE 27017

ADD docker-configs/mongodb/ /
ADD install/src/mongodb /opt/scot/install/src/mongodb

#add entry scripts
RUN chmod 0755 /run.sh
RUN chmod 0755 /set_mongodb_config.sh

#ADD demo files
ADD demo/ /opt/scot/demo/

#set mongodb UID to system created
RUN usermod -u 1061 mongodb 

#add user to scot group
RUN groupadd -g 2060 scot && \
     usermod -a -G 2060 mongodb

#Set permissions for mongodb user

RUN chown -R 1061:2060 /var/log/mongodb /var/lib/mongodb/

# Set /usr/bin/mongod as the dockerized entry-point application
USER mongodb:mongodb


CMD ["/run.sh"]