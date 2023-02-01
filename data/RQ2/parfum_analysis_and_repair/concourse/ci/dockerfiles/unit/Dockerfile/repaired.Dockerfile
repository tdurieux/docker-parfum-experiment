ARG base_image=concourse/golang-builder
FROM ${base_image}

# enable CGO so we can go test with -race
ENV CGO_ENABLED=1

# basic setup for adding new apt sources and installing packages
RUN apt-get update && apt-get -y --no-install-recommends install \
      apt-transport-https \
      ca-certificates \
      curl \
      iproute2 \
      gnupg2 \
      software-properties-common \
      unzip \
      file \
      btrfs-progs && rm -rf /var/lib/apt/lists/*;

# install PostgreSQL for DB tests
ENV DEBIAN_FRONTEND noninteractive
RUN curl -f https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main"
RUN apt-get update && apt-get -y --no-install-recommends install postgresql-13 && rm -rf /var/lib/apt/lists/*;
ENV PATH $PATH:/usr/lib/postgresql/13/bin

# install Node 16.x
RUN curl -f -sL https://deb.nodesource.com/setup_16.x | bash -
RUN apt-get update && apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install Yarn for web UI tests
RUN curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN add-apt-repository "deb https://dl.yarnpkg.com/debian/ stable main"
RUN apt-get update && apt-get -y --no-install-recommends install yarn && rm -rf /var/lib/apt/lists/*;

# install Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get update && apt-get -y --no-install-recommends install docker-ce && rm -rf /var/lib/apt/lists/*;

# install Docker Compose
RUN curl -f -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" \
      -o /usr/local/bin/docker-compose && \
      chmod +x /usr/local/bin/docker-compose

# install Chrome for Puppeteer (watsjs/upgrade/downgrade/smoke)
RUN curl -fsSL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN add-apt-repository "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main"
RUN apt-get update && apt-get -y install google-chrome-stable xvfb --no-install-recommends && rm -rf /var/lib/apt/lists/*;
# ensure that Puppeteer uses this Chrome instead of downloading on demand;
# this makes us resilient to breaking changes to the APT dependencies
ENV PUPPETEER_SKIP_DOWNLOAD=true \
    PUPPETEER_EXECUTABLE_PATH=/usr/bin/google-chrome-stable

# install BOSH CLI for bosh-smoke, bosh-topgun
RUN curl -f -L "https://github.com/cloudfoundry/bosh-cli/releases/download/v6.3.0/bosh-cli-6.3.0-linux-amd64" \
      -o /usr/local/bin/bosh && \
      chmod +x /usr/local/bin/bosh

# install kubectl for k8s-related jobs
RUN curl -f -L "https://dl.k8s.io/release/$( curl -f -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
      -o /usr/local/bin/kubectl && \
      chmod +x /usr/local/bin/kubectl

# install helm for k8s-related jobs
RUN curl -f https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

# install yq
RUN wget https://github.com/mikefarah/yq/releases/download/3.4.0/yq_linux_amd64 -O /usr/bin/yq &&\
    chmod +x /usr/bin/yq

# TODO: tech-debt for maintaining 6.3.x version of the chart which uses Helm v2
# Remove when 6.3.x no longer needs to be supported
RUN curl -f https://get.helm.sh/helm-v2.16.12-linux-amd64.tar.gz -o helm-v2.tar.gz && \
        tar xzf helm-v2.tar.gz && \
        mv linux-amd64/helm /usr/local/bin/helm2 && rm helm-v2.tar.gz

# install Vault for bosh-topgun
RUN curl -f -L https://releases.hashicorp.com/vault/0.7.3/vault_0.7.3_linux_amd64.zip -o /tmp/vault.zip && \
      unzip /tmp/vault.zip -d /usr/local/bin && \
      rm /tmp/vault.zip

# install Terraform, ssh and jq for bin-smoke
RUN curl -fsSL https://releases.hashicorp.com/terraform/0.14.5/terraform_0.14.5_linux_amd64.zip -o /tmp/terraform.zip && \
      unzip /tmp/terraform.zip -d /usr/local/bin && \
      rm /tmp/terraform.zip
RUN apt-get update && apt-get -y --no-install-recommends install jq openssh-client libnss3-tools && rm -rf /var/lib/apt/lists/*;

# install Let's Encrypt staging cert for 'curl', setting it an env var just so
# it's easier to discover if/when this changes again
ENV LETS_ENCRYPT_STAGING_CA_CERT=/usr/local/share/ca-certificates/letsencrypt-stg-root-x1.crt
RUN curl -f https://letsencrypt.org/certs/staging/letsencrypt-stg-root-x1.pem -o $LETS_ENCRYPT_STAGING_CA_CERT && \
      update-ca-certificates

# install Let's Encrypt staging cert to nssdb for Chrome
RUN mkdir -p /root/.pki/nssdb && \
  chmod 700 /root/.pki/nssdb && \
  certutil -N -d sql:/root/.pki/nssdb --empty-password && \
  certutil -A \
    -n "LetsEncrypt Staging Fake Root" \
    -t "TCu,Cu,Tu" \
    -i $LETS_ENCRYPT_STAGING_CA_CERT \
    -d sql:/root/.pki/nssdb

# install goimports CLI for formatting go files
RUN go install golang.org/x/tools/cmd/goimports@latest
