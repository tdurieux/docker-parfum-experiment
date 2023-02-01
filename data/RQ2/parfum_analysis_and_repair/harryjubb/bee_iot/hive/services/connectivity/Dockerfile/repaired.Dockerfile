FROM python:3.9.6

RUN mkdir /app
WORKDIR /app

COPY requirements.txt ./
RUN pip3 install --no-cache-dir -r requirements.txt

COPY connectivity.py entrypoint.sh ./

ENV PYTHONUNBUFFERED 1

ENTRYPOINT [ "sh", "/app/entrypoint.sh" ]
