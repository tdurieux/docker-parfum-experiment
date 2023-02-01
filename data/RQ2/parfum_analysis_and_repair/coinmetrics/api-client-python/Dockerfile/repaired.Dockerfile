FROM python:3.8.12-slim

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -qy \
      cargo \
      make \
      postgresql-server-dev-all \
      python3-dev \
      python3-protobuf \
      build-essential \
      ; rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir "poetry==1.1.5"
COPY pyproject.toml ./poetry.lock ./
RUN poetry config experimental.new-installer false
RUN poetry config virtualenvs.create false

RUN poetry install --no-root
RUN poetry install --no-root --extras "pandas"

COPY ./ ./

CMD [ "python" ]
