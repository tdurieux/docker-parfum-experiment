FROM openjdk:7
RUN apt-get update && apt-get install --no-install-recommends -y wget && wget https://www.exploit-db.com/apps/d913ae23ffc66d96a1e9296e5299155b-apache-continuum-1.4.2-bin.tar.gz && tar -zxf d913ae23ffc66d96a1e9296e5299155b-apache-continuum-1.4.2-bin.tar.gz && rm d913ae23ffc66d96a1e9296e5299155b-apache-continuum-1.4.2-bin.tar.gz && rm -rf /var/lib/apt/lists/*;

#CMD java -jar start.jar