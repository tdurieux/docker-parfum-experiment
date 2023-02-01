FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        python python-dev \
        python3 python3-dev \
        python-pip python-virtualenv python-tox \
        libchromaprint1 libchromaprint-tools libpq-dev \
        curl && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L -o /wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh
RUN chmod +rx /wait-for-it.sh
