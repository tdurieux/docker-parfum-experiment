FROM python:3.8.10 as pybuild1
LABEL maintainer="morgan@scaleoutsystems.com"
#RUN apk update
#RUN apk add musl-dev postgresql-dev gcc python3-dev linux-headers
RUN mkdir /app
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r /app/requirements.txt

RUN apt update
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
RUN chmod 700 get_helm.sh
RUN ./get_helm.sh
# ENV VERSION="3.0.2"
# ENV BASE_URL="https://get.helm.sh"
# ENV TAR_FILE="helm-v${VERSION}-linux-amd64.tar.gz"
# RUN apt update
# RUN apt install curl ca-certificates wget -y && \
#     curl -L ${BASE_URL}/${TAR_FILE} |tar xvz && \
#     mv linux-amd64/helm /usr/bin/helm && \
#     chmod +x /usr/bin/helm && \
#     rm -rf linux-amd64 && \
#     apt remove curl -y && \
#     rm -f /var/cache/apk/*

RUN apt update && apt install --no-install-recommends -y apt-transport-https gnupg2 curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt update
RUN apt install --no-install-recommends -y kubectl && rm -rf /var/lib/apt/lists/*;



FROM pybuild1

COPY . /app/

WORKDIR /app
