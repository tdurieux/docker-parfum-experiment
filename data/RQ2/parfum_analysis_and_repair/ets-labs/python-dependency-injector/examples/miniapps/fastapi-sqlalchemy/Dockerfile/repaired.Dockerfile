FROM python:3.10-buster

ENV PYTHONUNBUFFERED=1
ENV HOST=0.0.0.0
ENV PORT=8000

WORKDIR /code
COPY . /code/

RUN pip install --no-cache-dir --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

CMD uvicorn webapp.application:app --host ${HOST} --port ${PORT}
