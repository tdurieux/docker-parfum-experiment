FROM python:3.8-buster

WORKDIR /srv

RUN curl -f https://packages.microsoft.com/keys/microsoft.asc | apt-key add - \
  && curl -f https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
  && apt-get update \
  && ACCEPT_EULA=Y apt-get --no-install-recommends install -y unixodbc-dev msodbcsql17 dumb-init && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY cdc_kafka cdc_kafka

ENTRYPOINT ["dumb-init", "--rewrite", "15:2", "--"]
CMD ["python", "-m", "cdc_kafka"]
