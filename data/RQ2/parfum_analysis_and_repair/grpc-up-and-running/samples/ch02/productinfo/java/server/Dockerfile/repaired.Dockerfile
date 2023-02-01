# Pull base ubuntu image.
FROM ubuntu:latest

RUN \

 apt-get update -y && \
# Install Java JRE
apt-get install --no-install-recommends default-jre -y && rm -rf /var/lib/apt/lists/*;
# Copy the build files to the container.
ADD ./build/libs/server.jar server.jar
# Document that the service listens on port 50051.
EXPOSE 50051
# Run the server command when the container starts.
CMD java -jar server.jar