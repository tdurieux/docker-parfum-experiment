FROM ubuntu:18.04
MAINTAINER hans.zandbelt@oidf.org

RUN apt-get clean && apt-get --fix-missing update
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y git ntp curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get update && apt-get install --no-install-recommends -y gnupg && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs apache2 wget libgconf-2-4 && rm -rf /var/lib/apt/lists/*;

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main' | tee /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install --no-install-recommends -y google-chrome-stable libnss3-tools && rm -rf /var/lib/apt/lists/*;


WORKDIR /root
RUN git clone https://github.com/openid-certification/oidc-provider-conformance-tests.git
WORKDIR /root/oidc-provider-conformance-tests
RUN npm install --production && npm cache clean --force;
WORKDIR /root
RUN git clone https://github.com/openid-certification/openid-client-conformance-tests.git
WORKDIR /root/openid-client-conformance-tests
RUN npm install --production && npm cache clean --force;

COPY run.sh /root/run.sh
RUN chmod 755 /root/run.sh

ENTRYPOINT /root/run.sh