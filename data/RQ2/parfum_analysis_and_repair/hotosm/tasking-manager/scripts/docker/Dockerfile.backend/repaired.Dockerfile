FROM python:3.7-alpine as base
LABEL version=0.2
LABEL description="Builds docker image for TM Backend"

WORKDIR /usr/src/app

## BUILD STAGE
FROM base as builder

# Setup backend build dependencies
RUN apk update && \
    apk add --no-cache \
       gcc \
       g++ \
       make \
       musl-dev \
       libffi-dev \
       python3-dev \
       postgresql-dev \
       geos-dev \
       proj-util \
       proj-dev

# Setup backend Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir --prefix=/install --no-warn-script-location -r requirements.txt

## DEPLOY STAGE
FROM base

# Setup backend runtime dependencies
RUN apk update && apk add --no-cache postgresql-libs geos proj-util

COPY --from=builder /install /usr/local
COPY . .

ENV TZ UTC # Fix timezone (do not change - see issue #3638)
EXPOSE 5000

CMD ["gunicorn", "-c", "python:backend.gunicorn", "manage:application"]
