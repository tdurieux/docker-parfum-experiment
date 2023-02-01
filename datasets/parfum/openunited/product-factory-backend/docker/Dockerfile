FROM python:3.9.5-buster


COPY . /app
WORKDIR /app

RUN pip install --upgrade pip && pip install -r requirements.txt

COPY docker/entrypoint.sh /

RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
