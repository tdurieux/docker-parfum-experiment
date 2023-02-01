FROM python:3.6

RUN mkdir /app
WORKDIR /app

RUN apt-get -y update && apt-get -y --no-install-recommends install \
    gcc \
    python3-dev \
    build-essential \
    libjpeg-dev \
    musl-dev \
    zlib1g-dev \
    libfreetype6-dev && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /app/requirements.txt
RUN pip3 install --no-cache-dir -r /app/requirements.txt

COPY ./server.py /app/server.py
COPY ./random.png /app/random.png
COPY ./Roboto-Regular.ttf /app/Roboto-Regular.ttf

ENTRYPOINT [ "python3", "server.py" ]
