FROM python:3.9.5-slim-buster

WORKDIR /usr/src/app
COPY .. /usr/src/app
RUN mkdir -p ./media

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && apt-get install --no-install-recommends -y curl netcat && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;

EXPOSE 5000

RUN chmod +x ./docker/entrypoint.sh
ENTRYPOINT ["./docker/entrypoint.sh"]