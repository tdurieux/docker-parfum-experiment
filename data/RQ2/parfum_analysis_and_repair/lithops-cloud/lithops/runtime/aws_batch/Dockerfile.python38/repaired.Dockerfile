FROM python:3.8-slim-buster

RUN apt-get update && apt-get install --no-install-recommends -y \
        zip \
        && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade setuptools six pip \
    && pip install --no-cache-dir \
        boto3 \
        pika \
        glob2 \
        redis \
        requests \
        PyYAML \
        kubernetes \
        numpy \
        cloudpickle \
        ps-mem \
        tblib \
        matplotlib

# Copy Lithops proxy and lib to the container image.
ENV APP_HOME /lithops
WORKDIR $APP_HOME

COPY lithops_aws_batch.zip .
RUN unzip lithops_aws_batch.zip && rm lithops_aws_batch.zip

ENTRYPOINT python entry_point.py