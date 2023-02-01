FROM docker.io/barichello/godot-ci:latest


COPY . /app

RUN apt update && apt -y --no-install-recommends install python3 python3-setuptools && rm -rf /var/lib/apt/lists/*;

WORKDIR /app

RUN python3 setup.py install

ENTRYPOINT ["./generate_reference"]
