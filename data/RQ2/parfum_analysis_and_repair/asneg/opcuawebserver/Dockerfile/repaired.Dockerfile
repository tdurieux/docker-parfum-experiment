FROM asneg/opcuastack:release-4

# Add source files to docker container
ADD / /OpcUaWebServer

# Prepare Python dependencies for tests
RUN apt-get update && apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r /OpcUaWebServer/ftest/requirements.txt

# Prepare workdir
WORKDIR /OpcUaWebServer

# Build
RUN sh build.sh -t local -i / -j 2 -B Release

# Clean build files
RUN sh build.sh -t clean

# Start OpcUaWebServer
EXPOSE 8890 4840 8080 8081 8082 22
CMD ["OpcUaServer4", "/etc/OpcUaStack/OpcUaWebServer/OpcUaServer.xml"]
