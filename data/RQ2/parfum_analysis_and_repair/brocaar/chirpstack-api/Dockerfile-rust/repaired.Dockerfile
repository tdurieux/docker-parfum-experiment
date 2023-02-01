FROM rust:1.51

ENV PROJECT_PATH=/chirpstack-api
RUN apt-get update && \
	apt-get install --no-install-recommends -y make git bash && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/googleapis/googleapis.git /googleapis

RUN rustup component add rustfmt

RUN mkdir -p $PROJECT_PATH
COPY . $PROJECT_PATH
WORKDIR $PROJECT_PATH
