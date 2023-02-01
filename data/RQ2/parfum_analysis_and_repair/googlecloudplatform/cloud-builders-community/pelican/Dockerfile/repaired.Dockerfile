FROM python:3-alpine
RUN apk add --update \
    groff \
    less \
  && pip install --no-cache-dir pelican Markdown \
  && rm -rf /var/cache/apk/* ~/.cache/pip
ENV PAGER=less
ENTRYPOINT ["pelican"]
