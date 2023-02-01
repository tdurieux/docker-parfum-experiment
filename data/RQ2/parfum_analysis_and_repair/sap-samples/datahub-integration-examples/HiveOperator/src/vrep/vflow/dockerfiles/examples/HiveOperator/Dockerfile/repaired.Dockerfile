FROM python:3.6.4-slim-stretch

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
 apt install --no-install-recommends -y python3-pip && \
 apt-get install --no-install-recommends -y python3-dev && \
 apt-get install --no-install-recommends -y krb5-user && \
 apt-get install --no-install-recommends -y libsasl2-dev && \
 apt-get install --no-install-recommends -y libsasl2-modules-gssapi-mit && \
 mkdir /keytabs && rm -rf /var/lib/apt/lists/*;

# Install python libraries
RUN pip3 install --no-cache-dir pyhive[hive]
RUN pip3 install --no-cache-dir tornado==5.0.2


# Add vflow user and vflow group to prevent error
# container has runAsNonRoot and image will run as root
RUN groupadd -g 1972 vflow && useradd -g 1972 -u 1972 -m vflow
USER 1972:1972
WORKDIR /home/vflow
ENV HOME=/home/vflow