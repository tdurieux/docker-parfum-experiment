FROM python:2.7-alpine

COPY . /tweeviz
RUN pip install --no-cache-dir /tweeviz

WORKDIR /tweeviz

ENTRYPOINT ["./tweeviz.py"]
