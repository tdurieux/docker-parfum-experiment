FROM python:3.6-alpine
ARG version
RUN apk update && \
  apk add --no-cache postgresql-libs && \
  apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
  pip install tap-postgres==${version} --no-cache-dir && \
  apk --purge del .build-deps

WORKDIR /app
CMD ["tap-postgres"]