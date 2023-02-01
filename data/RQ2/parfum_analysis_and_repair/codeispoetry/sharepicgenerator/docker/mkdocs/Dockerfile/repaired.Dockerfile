FROM python:3.6
WORKDIR /mkdocs/
RUN pip install --no-cache-dir mkdocs mkdocs-bootstrap
EXPOSE 8080
CMD ["mkdocs", "serve"]