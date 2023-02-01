FROM python:3.7-alpine

WORKDIR /usr/src/app

COPY echo.py ./
RUN pip install --no-cache-dir websockets

ENTRYPOINT ["python", "./echo.py"]
