FROM python:3

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y gfortran libblas-dev liblapack-dev && \
    pip install --no-cache-dir numpy && \
    pip install --no-cache-dir scipy && \
    mkdir -p /usr/src/app && rm -rf /usr/src/app && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

COPY requirements.txt /usr/src/app/

RUN pip install --no-cache-dir -r requirements.txt

COPY . /usr/src/app

EXPOSE 8080

CMD [ "python", "-m", "service.worker" ]
