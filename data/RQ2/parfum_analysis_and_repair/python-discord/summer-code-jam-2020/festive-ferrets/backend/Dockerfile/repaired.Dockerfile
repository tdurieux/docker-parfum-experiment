FROM python:3.8

WORKDIR /usr/src/app

RUN apt update \
    && apt install --no-install-recommends -y python3-dev libpq-dev postgresql postgresql-contrib gcc musl-dev netcat && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend/ .

RUN chmod +x entrypoint.sh

ENTRYPOINT ["/usr/src/app/entrypoint.sh"]