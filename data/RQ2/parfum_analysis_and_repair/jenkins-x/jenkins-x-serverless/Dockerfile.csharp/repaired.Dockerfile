FROM jenkinsxio/jenkins-filerunner:0.1.49

RUN wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.asc.gpg && \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ && \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list && \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list && \
    chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg && \
    chown root:root /etc/apt/sources.list.d/microsoft-prod.list

RUN apt-get install --no-install-recommends -y apt-transport-https && \
    apt-get update && \
    apt-get install --no-install-recommends -y dotnet-sdk-2.1 && rm -rf /var/lib/apt/lists/*;

# jx
ENV JX_VERSION 2.0.835
RUN curl -Lf https://github.com/jenkins-x/jx/releases/download/v${JX_VERSION}/jx-linux-amd64.tar.gz | tar xzv && \
  mv jx /usr/bin/
