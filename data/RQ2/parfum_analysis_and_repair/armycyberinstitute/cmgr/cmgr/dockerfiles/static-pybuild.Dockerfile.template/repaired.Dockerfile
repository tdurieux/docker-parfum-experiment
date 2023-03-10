FROM ubuntu:20.04 AS base
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    gcc-multilib \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir ninja2
RUN install -d -m 0700 /challenge
# End of shared layers for all flask challenges

COPY Dockerfile packages.txt* ./
RUN if [ -f packages.txt ]; then apt-get update && xargs -a packages.txt apt-get install -y; fi

COPY Dockerfile requirements.txt* ./
RUN if [ -f requirements.txt ]; then \
 pip3 install --no-cache-dir -r requirements.txt; fi

COPY . /app
WORKDIR /app

# End of share layers for all builds of the same flask challenge
FROM base AS challenge

ARG FLAG_FORMAT
ARG FLAG
ARG SEED

RUN echo -n '{{PYBUILD}}' | base64 -d | python3
RUN mv metadata.json /challenge
RUN if [ -f artifacts.tar.gz ]; then mv artifacts.tar.gz /challenge; fi

RUN chmod +x start.sh

CMD tail -f /dev/null
