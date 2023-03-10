FROM python:3.9-alpine3.13

ENV PYTHONPATH "${PYTHONPATH}:/opt/python/lib/python3.9/site-packages"
ENV PYTHONDONTWRITEBYTECODE 1
ENV TASK_ROOT /app

RUN apk add --no-cache bash build-base git libtool cmake autoconf automake gcc musl-dev postgresql-dev g++ libc6-compat libexecinfo-dev make libffi-dev libmagic libcurl curl-dev rust cargo && rm -rf /var/cache/apk/*

# update pip
RUN python -m pip install wheel
RUN python -m pip install --upgrade pip

RUN set -ex && mkdir ${TASK_ROOT}

WORKDIR ${TASK_ROOT}

COPY requirements.txt ${TASK_ROOT}
RUN set -ex && pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir awslambdaric newrelic-lambda

COPY . ${TASK_ROOT}

RUN make generate-version-file

ENV PORT=6011

ARG GIT_SHA
ENV GIT_SHA ${GIT_SHA}

# (Optional) Add Lambda Runtime Interface Emulator and use a script in the ENTRYPOINT for simpler local runs
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/bin/aws-lambda-rie
COPY bin/entry.sh /
COPY bin/sync_lambda_envs.sh /
RUN chmod 755 /usr/bin/aws-lambda-rie /entry.sh /sync_lambda_envs.sh

# New Relic lambda layer
RUN unzip newrelic-layer.zip -d /opt && rm newrelic-layer.zip

ENTRYPOINT [ "/entry.sh" ]

# Launch the New Relic lambda wrapper which will then launch the app
# handler defined in the NEW_RELIC_LAMBDA_HANDLER environment variable
CMD [ "newrelic_lambda_wrapper.handler" ]