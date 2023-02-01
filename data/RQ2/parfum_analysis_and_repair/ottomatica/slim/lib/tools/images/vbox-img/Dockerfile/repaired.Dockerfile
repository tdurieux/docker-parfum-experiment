FROM ubuntu:20.04 as install

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && \
    apt install --no-install-recommends curl -y && rm -rf /var/lib/apt/lists/*;

ENV VIRTUALBOX=virtualbox-6.1_6.1.30-148432~Ubuntu~eoan_amd64.deb
RUN curl -f -s -O https://download.virtualbox.org/virtualbox/6.1.30/$VIRTUALBOX
RUN apt install --no-install-recommends ./$VIRTUALBOX -y && rm -rf /var/lib/apt/lists/*;

FROM ubuntu:20.04
COPY --from=install /usr/bin/vbox-img /usr/bin/vbox-img
# Library dependencies
RUN apt update && \
    apt install --no-install-recommends libxml2 -y && rm -rf /var/lib/apt/lists/*;