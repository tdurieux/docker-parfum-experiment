FROM python:3.9-slim

RUN apt update && apt install --no-install-recommends -y gcc git && apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists/*

# Set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

COPY ./src /app
COPY ./scripts /app/scripts

RUN pip install --no-cache-dir -r requirements.postgres.txt

CMD ["/bin/bash", "/app/scripts/runserver.sh"]
