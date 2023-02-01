FROM java:latest
RUN apt-get update && apt-get -y --no-install-recommends install maven && rm -rf /var/lib/apt/lists/*;
ADD . /code
WORKDIR /code
RUN mvn package
ENTRYPOINT ["java","-cp", "/code/target/osm-around-1.0.0-jar-with-dependencies.jar", "com.aerospike.osm.Around"]