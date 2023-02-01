# offical docker image of python debian buster variant
ARG PY_BASE_IMG

FROM ${PY_BASE_IMG}

RUN apt-get update -y && apt-get install --no-install-recommends -y python3-dev libev-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app

COPY requirements.txt /app
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . /app

ENV PYTHONUNBUFFERED 1
ENTRYPOINT ["python3"]
CMD ["server.py"]
