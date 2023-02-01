FROM python:3.7.3-alpine3.10

### install python3 dependencies you need
RUN pip3 install --no-cache-dir pyfiglet

COPY ./src /app

ENTRYPOINT ["python", "/app/app.py"]
