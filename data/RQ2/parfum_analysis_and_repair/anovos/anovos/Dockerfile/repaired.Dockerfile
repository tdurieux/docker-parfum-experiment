ARG spark_version=3.2.1
ARG image_version=latest

FROM anovos/anovos-notebook-${spark_version}:${image_version}

WORKDIR /

COPY requirements.txt /
COPY dev_requirements.txt /

RUN pip install --no-cache-dir -r requirements.txt && pip install --no-cache-dir -r dev_requirements.txt