FROM python:3.7-alpine

RUN pip install --no-cache-dir Flask Flask-Cors requests

ENV PYTHONPATH=/

COPY . /
WORKDIR /app

ENTRYPOINT [ "flask" ]

CMD [ "run","--host","0.0.0.0" ]