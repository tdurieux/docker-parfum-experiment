FROM node:10
EXPOSE 3000 9229

# Install kustomize
RUN curl -f -L "https://github.com/kubernetes-sigs/kustomize/releases/download/v2.0.3/kustomize_2.0.3_linux_amd64" > /tmp/kustomize && \
  chmod a+x /tmp/kustomize && \
  mv /tmp/kustomize "/usr/local/bin/kustomize2.0.3"

# Install kustomize 3
RUN curl -f -L "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.4/kustomize_v3.5.4_linux_amd64.tar.gz" > /tmp/kustomize.tar.gz && \
  tar -xzvf /tmp/kustomize.tar.gz && \
  rm /tmp/kustomize.tar.gz && \
  chmod a+x kustomize && \
  mv kustomize "/usr/local/bin/kustomize3.5.4"

RUN curl -f -L "https://github.com/replicatedhq/kots/releases/download/v1.15.2/kots.so_linux_amd64.tar.gz" > /tmp/kots.tar.gz && \
cd /tmp && tar xzvf kots.tar.gz && \
mv /tmp/kots.so /lib/kots.so && rm kots.tar.gz

RUN curl -f -L "https://github.com/replicatedhq/troubleshoot/releases/download/v0.9.31/troubleshoot.so_linux_amd64.tar.gz" > /tmp/troubleshoot.tar.gz && \
 cd /tmp && tar xzvf troubleshoot.tar.gz && \
 mv /tmp/troubleshoot.so /lib/troubleshoot.so && rm troubleshoot.tar.gz

ADD ./deploy/policy.json /etc/containers/policy.json
RUN apt-get -y update && apt-get install -y --no-install-recommends \
    ca-certificates libgpgme-dev libdevmapper-dev \
  && rm -rf /var/lib/apt/lists/*

ADD ./package.json /src/package.json
ADD ./package-lock.json /src/package-lock.json
WORKDIR /src
RUN npm i --silent && npm cache clean --force;

WORKDIR /src
ADD ./Makefile /src/
ADD ./tsconfig.json /src/
ADD ./src /src/src

RUN make build

# COPY ./kots.so /lib/kots.so
# COPY ./troubleshoot.so /lib/troubleshoot.so

ENTRYPOINT ["node", "--no-deprecation", "/src/build/server/index.js"]
