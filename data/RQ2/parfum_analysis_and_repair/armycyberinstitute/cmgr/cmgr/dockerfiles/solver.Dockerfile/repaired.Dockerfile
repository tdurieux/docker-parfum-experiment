FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    python3-pip && rm -rf /var/lib/apt/lists/*;

COPY Dockerfile packages.txt* ./
RUN if [ -f packages.txt ]; then apt-get update && xargs -a packages.txt apt-get install -y; fi

COPY Dockerfile requirements.txt* ./
RUN if [ -f requirements.txt ]; then \
 pip3 install --no-cache-dir -r requirements.txt; fi

COPY . /solve
WORKDIR /solve

CMD python3 solve.py
