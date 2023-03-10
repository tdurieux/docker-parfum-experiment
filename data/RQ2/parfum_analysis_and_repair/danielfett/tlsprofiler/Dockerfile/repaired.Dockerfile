FROM python:3.7-buster

RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src

RUN git clone https://github.com/fabian-hk/nassl.git

WORKDIR /usr/src/nassl

RUN git checkout tls_profiler

RUN pip install --no-cache-dir invoke requests

RUN invoke build.all

RUN pip install --no-cache-dir .

WORKDIR /usr/src/tlsprofiler

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

ENTRYPOINT ["python", "run.py"]
