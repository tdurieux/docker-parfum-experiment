FROM alpine/helm:2.16.9

ADD . /workspace

WORKDIR /workspace

RUN helm init -c
RUN helm plugin install .
RUN helm version -c

FROM alpine/helm:3.2.4

ADD . /workspace

WORKDIR /workspace

RUN helm plugin install .
RUN helm version -c

FROM ubuntu:focal

ADD . /workspace

WORKDIR /workspace

# See "From Apt (Debian/Ubuntu)" at https://helm.sh/docs/intro/install/
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    curl -f https://helm.baltorepo.com/organization/signing.asc | sudo apt-key add - && \
    apt-get install --no-install-recommends apt-transport-https --yes && \
    echo "deb https://baltocdn.com/helm/stable/debian/ all main" | tee /etc/apt/sources.list.d/helm-stable-debian.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends helm && rm -rf /var/lib/apt/lists/*;

RUN helm plugin install .
RUN helm version -c
