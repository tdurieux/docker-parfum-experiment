FROM ubuntu:17.10

RUN apt-get update -y && apt-get install --no-install-recommends -y \
    curl \
    python-pip \
    postgresql-client \
    python-xmlrunner \
    python-requests \
    python-psycopg2 \
    python-jwt \
    python-crypto \
    python-cryptography \
    git && rm -rf /var/lib/apt/lists/*;

RUN mkdir /project
WORKDIR /project

RUN curl -f -LO https://storage.googleapis.com/kubernetes-release/release/$( curl -f -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x /project/kubectl

RUN curl -f -LO https://storage.googleapis.com/kubernetes-helm/helm-v2.8.2-linux-amd64.tar.gz && \
    tar xvf helm-v2.8.2-linux-amd64.tar.gz && \
    mv ./linux-amd64/helm ./helm && \
    rm -rf linux-amd64 && \
    rm helm-v2.8.2-linux-amd64.tar.gz && \
    ls -al /project

ENV PATH=$PATH:/project
ENV PYTHONPATH=/infrabox/context/src

CMD /infrabox/context/infrabox/test/e2e/entrypoint.sh
