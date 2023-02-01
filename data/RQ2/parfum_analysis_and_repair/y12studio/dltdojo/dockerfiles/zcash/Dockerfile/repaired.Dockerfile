FROM ubuntu:latest
# https://github.com/zcash/zcash/wiki/Debian-binary-packages
RUN apt-get update ; apt-get install --no-install-recommends -y apt-transport-https wget apt-utils; rm -rf /var/lib/apt/lists/*; \
    wget -qO - https://apt.z.cash/zcash.asc | apt-key add - ; \
    echo "deb [arch=amd64] https://apt.z.cash/ jessie main" | tee /etc/apt/sources.list.d/zcash.list ; \
    apt-get update ; apt-get install --no-install-recommends -y zcash
RUN zcash-fetch-params
ADD zcash.conf /root/.zcash/
