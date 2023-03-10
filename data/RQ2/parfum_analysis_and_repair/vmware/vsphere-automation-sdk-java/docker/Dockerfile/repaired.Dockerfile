FROM maven:3.6.3-jdk-8
MAINTAINER dx-sdk-iac@groups.vmware.com

# Set the working directory to /work
WORKDIR /work

# Update and install packages
RUN apt-get update && apt-get -y --no-install-recommends install vim \
    apt-utils \
    git && rm -rf /var/lib/apt/lists/*;

# Clone the project
RUN git clone https://github.com/vmware/vsphere-automation-sdk-java.git

# Build the samples
WORKDIR /work/vsphere-automation-sdk-java/
RUN mvn initialize; mvn clean install
CMD ["/bin/bash"]
