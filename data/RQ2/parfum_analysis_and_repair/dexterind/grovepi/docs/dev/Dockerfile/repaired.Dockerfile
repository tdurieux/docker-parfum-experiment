FROM python:alpine3.7

RUN pip install --no-cache-dir mkdocs mkdocs-material

WORKDIR /docs

CMD ["mkdocs", "serve", "--livereload", "-a", "0.0.0.0:8000"]
