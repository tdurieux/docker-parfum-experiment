FROM golang:1.18
ENV PATH=/root/.local/bin:$PATH
RUN apt update \
&& apt -y --no-install-recommends install \
devscripts \
fakeroot \
debhelper \
pkg-config \
alien \
rpm \
dh-make \
dh-golang \
upx-ucl \
python3 \
python3-pip \
&& pip3 install --no-cache-dir --upgrade --user jsonschema schemathesis && rm -rf /var/lib/apt/lists/*;
ADD https://github.com/ovh/venom/releases/download/v1.0.0-rc.7/venom.linux-amd64 /usr/bin/venom
RUN chmod ug+x /usr/bin/venom
