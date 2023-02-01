FROM keppel.eu-de-1.cloud.sap/ccloud-dockerhub-mirror/library/alpine:latest
LABEL source_repository="https://github.com/sapcc/vrops-exporter"

RUN apk --update --no-cache add python3 openssl ca-certificates bash python3-dev git py3-pip && \
    apk --update --no-cache add --virtual build-dependencies libffi-dev openssl-dev libxml2 libxml2-dev libxslt libxslt-dev build-base
RUN git config --global http.sslVerify false
RUN git clone https://github.com/sapcc/vrops-exporter.git
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --ignore-installed six
RUN pip install --no-cache-dir --upgrade cffi

ADD . vrops-exporter/
RUN pip3 install --no-cache-dir --upgrade -r vrops-exporter/requirements.txt

WORKDIR vrops-exporter/
