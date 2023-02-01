# Install JQ to pretty print JSON.
RUN apt-get update && DEBIAN_FRONTEND="noninteractive" apt-get -y install --assume-yes --no-install-recommends \
    jq && rm -rf /var/lib/apt/lists/*;

COPY ["spec/target_features.py", "/"]
COPY ["spec/target_features.sh", "/"]
RUN ARCH=^ARCH^ OS=^OS^ FLAGS=^FLAGS^ OPTIONAL_FLAGS=^OPTIONAL_FLAGS^ CC=^CC^ CXX=^CXX^ LINKER=^LINKER^ /target_features.sh
RUN rm /target_features.py
RUN rm /target_features.sh
