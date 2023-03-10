# Set up base image
FROM ubuntu
RUN apt-get update
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl apt-transport-https ca-certificates gnupg software-properties-common && rm -rf /var/lib/apt/lists/*;
# Docker
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update
RUN apt-get install --no-install-recommends -y docker-ce-cli && rm -rf /var/lib/apt/lists/*;
# Google Cloud SDK
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl -f https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
RUN apt-get update
RUN apt-get install --no-install-recommends -y google-cloud-sdk && rm -rf /var/lib/apt/lists/*;

# Build Plywood documentation & webserver
RUN apt-get install --no-install-recommends -y libsass-dev && rm -rf /var/lib/apt/lists/*;
COPY plywood /home/plywood
WORKDIR /home/plywood
RUN sed -i 's/WEBCOOKDOCS_LINK_TO_GITHUB 0/WEBCOOKDOCS_LINK_TO_GITHUB 1/' repos/plywood/src/web/web.modules.cpp
RUN cmake -DNO_BACKUP=1 -DPRESET=make -P Setup.cmake
RUN ./plytool folder create docs
RUN ./plytool target add WebCooker
RUN ./plytool target add WebServer
RUN ./plytool extern select libsass.apt
RUN ./plytool run WebCooker
RUN ./plytool build WebServer

# Prepare Dockerfile for webserver
WORKDIR /home/deploy
RUN cp /home/plywood/data/build/docs/build/Debug/WebServer .
RUN cp -r /home/plywood/data/docsite .
COPY Dockerfile-deploy Dockerfile
COPY deploy.sh deploy.sh
