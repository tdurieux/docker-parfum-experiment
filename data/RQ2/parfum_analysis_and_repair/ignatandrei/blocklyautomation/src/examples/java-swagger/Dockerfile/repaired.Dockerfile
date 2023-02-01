#Build from java soruces
FROM maven:3.8 as compile

# copy from PC to /usr/src/mymaven and set the work dir
COPY . /usr/src/mymaven
WORKDIR /usr/src/mymaven

RUN mvn clean install

#Deploy iy