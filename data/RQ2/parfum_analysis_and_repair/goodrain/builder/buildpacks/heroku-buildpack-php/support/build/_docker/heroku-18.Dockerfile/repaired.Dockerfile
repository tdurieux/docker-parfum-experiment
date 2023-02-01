FROM heroku/heroku:18-build

WORKDIR /app
ENV WORKSPACE_DIR=/app/support/build
ENV PATH=/app/support/build/_util:$PATH
ENV S3_BUCKET=lang-php
ENV S3_PREFIX=dist-heroku-18-develop/
ENV S3_REGION=s3
ENV STACK=heroku-18

RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir -r /app/requirements.txt

COPY . /app
