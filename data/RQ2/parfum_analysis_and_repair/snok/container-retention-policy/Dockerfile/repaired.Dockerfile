FROM python:3.10.2-alpine

RUN apk add --no-cache build-base

RUN pip install --no-cache-dir \



    regex==2022.3.2 \
    httpx \
    dateparser \
    pydantic

COPY main.py /main.py

ENTRYPOINT ["python", "/main.py"]
