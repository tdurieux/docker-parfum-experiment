FROM gcc:10

ENV PISA_SRC="/pisa"
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/New_York

WORKDIR $PISA_SRC

RUN apt-get update -y && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
