FROM python:3.7-slim-buster

WORKDIR /docs

RUN pip install --no-cache-dir mkdocs
RUN pip install --no-cache-dir mkdocs-render-swagger-plugin
RUN pip install --no-cache-dir mkdocs-material

COPY . .


EXPOSE 8080

ENTRYPOINT ["mkdocs", "serve"]
