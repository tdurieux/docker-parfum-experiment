from node:latest as swagger-bundle

WORKDIR /usr/src/
COPY . .

RUN npm install -g swagger-cli && npm cache clean --force;

RUN swagger-cli bundle openapi_server/openapi/openapi.yaml \
    --outfile openapi_server/_spec/openapi.yaml \
    --type yaml

FROM python:3-alpine

RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/

COPY --from=swagger-bundle /usr/src/openapi_server/_spec/openapi.yaml openapi_server/_spec/openapi.yaml

RUN apk update && apk add --no-cache build-base

RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 8080

ENTRYPOINT ["python3"]

CMD ["-m", "openapi_server"]
