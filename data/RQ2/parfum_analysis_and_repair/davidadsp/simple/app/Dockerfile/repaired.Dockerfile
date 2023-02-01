FROM ubuntu:bionic-20200219 as base

RUN apt-get update
RUN apt-get -y --no-install-recommends install ssh && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install htop && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libpq-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get update
RUN apt-get -y --no-install-recommends install cmake libopenmpi-dev python3-dev zlib1g-dev libgl1-mesa-dev && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools

RUN useradd -ms /bin/bash selfplay
USER selfplay
ENV PATH="/home/selfplay/.local/bin:${PATH}"
WORKDIR /app


COPY --chown=selfplay:selfplay ./app/requirements.txt /app
RUN pip3 install --no-cache-dir -r /app/requirements.txt

COPY --chown=selfplay:selfplay ./app .

ENV PYTHONIOENCODING=utf-8
ENV LC_ALL=C.UTF-8
ENV export LANG=C.UTF-8

CMD bash
