FROM openjdk:7
RUN apt-get update  && apt-get install -y wget && wget http://archive.apache.org/dist/portals/pluto/pluto-bundle-3.0.0.zip && unzip pluto-bundle-3.0.0.zip
WORKDIR /pluto-3.0.0/bin
RUN chmod +x *.sh 
CMD ./startup.sh && tail -f ../logs/*