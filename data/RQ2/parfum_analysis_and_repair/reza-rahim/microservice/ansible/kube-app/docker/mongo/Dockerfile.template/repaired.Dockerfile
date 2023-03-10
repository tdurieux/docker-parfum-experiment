FROM dckreg:5000/openjdk:8-jdk

# Install MongoDB.

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

RUN echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" |  tee /etc/apt/sources.list.d/mongodb-org-3.2.list

RUN apt-get update && apt-get install --no-install-recommends -y mongodb-org={{ MONGO_VERSION }} && rm -rf /var/lib/apt/lists/*;

COPY startmongo.sh /root/startmongo.sh

RUN chmod 755 /root/startmongo.sh

