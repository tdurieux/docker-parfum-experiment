FROM python:3.7-alpine
RUN wget -qO /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(wget -qO - https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl &&\
    chmod +x /usr/local/bin/kubectl
RUN apk --update --no-cache add bash jq && \
    apk add --no-cache --virtual build-deps gcc python-dev musl-dev && \
    apk add --no-cache postgresql-dev
COPY ckan_cloud_operator /usr/src/ckan-cloud-operator/ckan_cloud_operator
COPY *.sh *.py /usr/src/ckan-cloud-operator/
RUN python3 -m pip install psycopg2 pyyaml kubernetes click toml requests
RUN python3 -m pip install -e /usr/src/ckan-cloud-operator
ENTRYPOINT ["ckan-cloud-operator"]
