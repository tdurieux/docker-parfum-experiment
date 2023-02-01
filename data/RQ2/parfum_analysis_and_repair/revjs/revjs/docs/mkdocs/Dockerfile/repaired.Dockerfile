FROM python:3-alpine

RUN pip install --no-cache-dir mkdocs
RUN pip install --no-cache-dir markdown-include

WORKDIR /mkdocs

CMD [ "mkdocs", "build" ]