FROM python:3.8-slim-buster

RUN apt update && apt install --no-install-recommends git gcc -y && rm -rf /var/lib/apt/lists/*;

RUN apt install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir virtualenv

WORKDIR /app

ADD ./requirements.txt ./

ADD ./Makefile ./

RUN make install-deps

COPY . /app

CMD ["make", "run-with-emulator"]
