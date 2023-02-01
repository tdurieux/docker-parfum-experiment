# Dockerfile for the iocreporter

FROM python:3.9-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
ADD ./iocreporter ./iocreporter
ADD ./libs ./libs
ADD ./extensions ./extensions
WORKDIR /app/iocreporter

EXPOSE 8084

CMD [ "python", "app.py", "runserver" ]
