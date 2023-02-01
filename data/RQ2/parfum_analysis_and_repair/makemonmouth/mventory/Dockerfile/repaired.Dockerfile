FROM python:3.8-slim-buster
ENV PYTHONUNBUFFERED=1
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends -y gcc libmariadbclient-dev libsqlite3-dev libpq-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /opt/app
COPY requirements.txt /opt/app/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /opt/app
RUN rm -rf /opt/app/data/*.sqlite3

EXPOSE 8000

ENTRYPOINT ["./scripts/prod_deploy.sh"]
