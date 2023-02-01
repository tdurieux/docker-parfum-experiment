FROM ubuntu:14.04

RUN sudo apt-get update && apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;

RUN sudo pip install --no-cache-dir flask==0.10.1

COPY . /usr/bin

WORKDIR /usr/bin

EXPOSE 5000

CMD ["python", "./app.py"]
