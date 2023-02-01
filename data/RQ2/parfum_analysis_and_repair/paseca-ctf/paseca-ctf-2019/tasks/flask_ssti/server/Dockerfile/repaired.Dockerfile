FROM python:3.7-alpine

COPY ./app /app

RUN pip install --no-cache-dir -r app/requirements.txt

USER nobody:nogroup

WORKDIR /app

CMD python app.py
