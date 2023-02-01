# This is used as a base image when building in Jenkins
FROM openjdk:8u242-jre
RUN apt-get update
RUN apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;

## # install yq - a YAML query command line tool
RUN curl -f -Lso yq https://github.com/mikefarah/yq/releases/download/2.2.1/yq_linux_amd64
RUN chmod +x yq
RUN mv yq /usr/local/bin

RUN pip3 install --no-cache-dir awscli

## After creating the image, upload it to us.gcr.io/platform-205701/harness/serverjre_8