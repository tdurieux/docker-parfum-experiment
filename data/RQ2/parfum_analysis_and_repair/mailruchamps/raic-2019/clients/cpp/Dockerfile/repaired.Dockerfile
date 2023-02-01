FROM gcc

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;

COPY . /project
WORKDIR /project