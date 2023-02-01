FROM python:alpine

WORKDIR /app

COPY app/requirements.txt /app

RUN pip install -r requirements.txt

COPY app/* /app

CMD [ "python", "/app/jobrunner.py"]
