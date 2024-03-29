FROM python:3.7-slim-buster

RUN apt-get update

# working with timezones
RUN apt-get install --no-install-recommends --yes tzdata && rm -rf /var/lib/apt/lists/*;
# confluent-kafka-python needs these
RUN apt-get install --no-install-recommends --yes librdkafka-dev python3-dev && rm -rf /var/lib/apt/lists/*;
# psycopg2 needs these
RUN apt-get install --no-install-recommends --yes build-essential libpq-dev && rm -rf /var/lib/apt/lists/*;

# activate virtualenv
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

# upgrading pip solves many installation problems
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir gunicorn==20.1.0

WORKDIR /restknotapi

# leverage Docker cache
COPY ./requirements.txt /restknotapi/requirements.txt

COPY ./config.yml /restknotapi/config.yml

RUN pip3 install --no-cache-dir -r /restknotapi/requirements.txt

ARG BUILD_VERSION
RUN echo "$BUILD_VERSION" > build-version.txt

COPY . /restknotapi
# check build version
RUN cat /restknotapi/build-version.txt

EXPOSE 5000
CMD ["gunicorn", "autoapp:app", "-b", "0.0.0.0:5000"]
