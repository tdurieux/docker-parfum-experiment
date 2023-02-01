FROM frolvlad/alpine-python3:latest

WORKDIR /src

COPY . /src/

RUN pip3 install --no-cache-dir .

ENTRYPOINT ["./wrapper"]
