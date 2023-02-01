FROM python:3.9-alpine

RUN pip install --no-cache-dir httpx==0.18.2


COPY . /action

ENTRYPOINT ["python", "/action/main.py"]
