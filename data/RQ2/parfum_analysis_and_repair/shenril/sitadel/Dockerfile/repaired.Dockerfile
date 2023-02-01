FROM python:3

WORKDIR /usr/src/app
COPY . /usr/src/app

RUN pip3 install --no-cache-dir .

ENTRYPOINT ["python", "sitadel.py"]
