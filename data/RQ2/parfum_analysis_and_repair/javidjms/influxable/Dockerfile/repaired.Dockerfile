FROM python:3.7.3
ENV PYTHONUNBUFFERED 1
ARG ENV

RUN apt-get update && apt-get install --no-install-recommends -y \
  gcc \
  musl-dev \
  build-essential \
  libssl-dev \
  libffi-dev \
  python3.5-dev \
  libldap2-dev \
  libsasl2-dev \
  libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app/
WORKDIR /app/
COPY requirements.txt /app/requirements.txt
COPY requirements-dev.txt /app/requirements-dev.txt

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY . /app/

CMD tail -f /dev/null
