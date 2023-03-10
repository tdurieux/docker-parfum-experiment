FROM python:3.10

WORKDIR /usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y \
    graphviz \
 && rm -rf /var/lib/apt/lists/*

COPY requirements-setuptools.txt ./
RUN pip install --no-cache-dir -r requirements-setuptools.txt

COPY . .
RUN pip install --no-cache-dir -e .[server] -c requirements.txt

VOLUME ["/data"]
ENTRYPOINT ["python", "-m", "randovania"]
CMD ["--configuration", "/data/configuration.json", "server", "flask"]
