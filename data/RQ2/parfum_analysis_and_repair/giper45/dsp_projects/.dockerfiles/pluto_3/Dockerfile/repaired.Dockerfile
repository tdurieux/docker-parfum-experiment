FROM openjdk:7
RUN apt-get update && apt-get install --no-install-recommends -y wget && wget https://archive.apache.org/dist/portals/pluto/pluto-bundle-3.0.0.zip && unzip pluto-bundle-3.0.0.zip && rm -rf /var/lib/apt/lists/*;
WORKDIR /pluto-3.0.0/bin
RUN chmod +x *.sh
CMD ./startup.sh && tail -f ../logs/*