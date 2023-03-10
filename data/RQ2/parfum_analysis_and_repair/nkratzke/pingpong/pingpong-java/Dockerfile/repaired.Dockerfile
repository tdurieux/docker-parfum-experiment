FROM ubuntu

MAINTAINER Nane Kratzke

# Update the system
RUN sudo apt-get update
RUN sudo apt-get install --no-install-recommends software-properties-common python-software-properties -y && rm -rf /var/lib/apt/lists/*;

# Copy sources and install script
ADD src /pingpong/src
ADD install.sh /pingpong/install.sh

# Install
WORKDIR /pingpong/
RUN /pingpong/install.sh

EXPOSE 80

ENTRYPOINT ["java", "-classpath", "bin"]
CMD ["Pong", "80"]