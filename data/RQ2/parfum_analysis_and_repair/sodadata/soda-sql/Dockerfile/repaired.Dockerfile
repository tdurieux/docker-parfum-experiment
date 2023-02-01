FROM python:3.7

RUN apt-get update && apt-get -y --no-install-recommends install gcc libsasl2-dev python-dev unixodbc-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /app

WORKDIR /app

RUN pip install --no-cache-dir --upgrade pip

COPY . .

RUN pip install --no-cache-dir "$(cat dev-requirements.in | grep pip-tools)" && \
    pip install --no-cache-dir -r dev-requirements.txt && \
    pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "soda" ]
CMD [ "scan" ]
