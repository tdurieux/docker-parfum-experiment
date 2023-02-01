FROM python:3.7-alpine
RUN apk --update --no-cache add git && \
    pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir dep-license

CMD ["deplic"]
