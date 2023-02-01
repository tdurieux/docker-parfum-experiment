FROM ubuntu
# ubuntu does not ship with curl as default
RUN apt update -y && apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /root/trial
WORKDIR /root/trial
ADD download.sh /root/trial/download.sh
RUN /root/trial/download.sh
RUN /root/trial/mondoo version