FROM python:3.8

RUN mkdir /app
WORKDIR /app

RUN apt update && \
    apt install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . .