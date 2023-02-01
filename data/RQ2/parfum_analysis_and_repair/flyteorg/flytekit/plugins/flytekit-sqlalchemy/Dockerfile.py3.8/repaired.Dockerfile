FROM python:3.8-slim-buster

WORKDIR /app
ENV VENV /opt/venv
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONPATH /app

RUN pip install --no-cache-dir awscli
RUN pip install --no-cache-dir gsutil

ARG VERSION

# Virtual environment
RUN python3.8 -m venv ${VENV}
RUN ${VENV}/bin/pip install --no-cache-dir wheel

RUN ${VENV}/bin/pip install --no-cache-dir sqlalchemy psycopg2-binary pymysql flytekitplugins-sqlalchemy==$VERSION flytekit==$VERSION

# Copy over the helper script that the SDK relies on
RUN cp ${VENV}/bin/flytekit_venv /usr/local/bin
RUN chmod a+x /usr/local/bin/flytekit_venv

# Enable the virtualenv for this image. Note this relies on the VENV variable we've set in this image.
ENTRYPOINT ["/usr/local/bin/flytekit_venv"]
