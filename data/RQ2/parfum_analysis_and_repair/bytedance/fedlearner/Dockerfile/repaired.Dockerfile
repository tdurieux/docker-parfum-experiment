FROM python:3.6
WORKDIR /app

COPY . /app

RUN apt-get -y update \
    && apt-get -y --no-install-recommends install cron \
    && apt-get -y --no-install-recommends install libgmp-dev \
    && apt-get -y --no-install-recommends install libmpfr-dev \
    && apt-get -y --no-install-recommends install libmpc-dev \
    # For krb5-user installation
    && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y --no-install-recommends install krb5-user \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt \
    && rm -rf ~/.cache/pip

RUN make protobuf \
    && make op

ENV PYTHONPATH=/app:$PYTHONPATH
ENV TZ="Asia/Shanghai"

CMD []
