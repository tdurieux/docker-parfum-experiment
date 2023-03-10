FROM dockerfile/java:oracle-java8
MAINTAINER Andreas Kluth <mail@andreaskluth.net>

# Update and install mvn, remove the updated lists afterwards
RUN apt-get update && apt-get install --no-install-recommends -y maven && rm -rf /var/lib/apt/lists/*

# Add the wd
ADD . /code
WORKDIR /code

# Build the app
# Copy the jar and remove the code.
# Remove the now obsolete mvn cache
RUN mvn clean install \
    && mkdir /app \
    && cp target/toast-on-atmosphere-0.0.6-SNAPSHOT.jar /app \
    && rm -rf /code && rm -rf /root/.m2/ \
    && apt-get -y purge maven \
    && apt-get clean

# Switch to the jar
WORKDIR /app

# Start
EXPOSE 8080
CMD java -XX:MaxMetaspaceSize=192m -Xss256k -Xms128m -Xmx288m -jar toast-on-atmosphere-0.0.6-SNAPSHOT.jar