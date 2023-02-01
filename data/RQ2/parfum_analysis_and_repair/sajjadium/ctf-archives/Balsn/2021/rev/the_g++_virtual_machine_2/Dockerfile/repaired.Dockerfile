FROM gcc:11.2.0

COPY ./src /src

RUN apt-get update; apt-get install --no-install-recommends -y libboost-all-dev; rm -rf /var/lib/apt/lists/*; exit 0

CMD "/bin/bash"
