FROM python:3.8

WORKDIR /usr/local/

COPY . .

RUN apt-get update && apt install --no-install-recommends -y libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN python3 setup.py develop

ENTRYPOINT ["python3","eden/tests/start_server.py"]