FROM node:12

ENV PROJECT_PATH=/chirpstack/api
RUN apt update && apt install --no-install-recommends -y protobuf-compiler libprotobuf-dev git bash && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/googleapis/googleapis.git /googleapis

RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH
