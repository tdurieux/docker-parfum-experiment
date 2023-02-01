# to be used when building in Jenkins
FROM openjdk:8u242-jre

RUN apt-get update
RUN apt install --no-install-recommends -y traceroute && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y nmap && rm -rf /var/lib/apt/lists/*;

# install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

## After creating the image, upload it to us.gcr.io/platform-205701/harness/serverjre_8