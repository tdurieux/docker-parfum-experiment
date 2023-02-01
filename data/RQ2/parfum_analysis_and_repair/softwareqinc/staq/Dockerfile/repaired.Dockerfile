FROM ubuntu:latest
ENV TZ="America/Toronto"
RUN apt-get update && \
    apt-get -y update && \
    apt-get install --no-install-recommends -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Toronto /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y \
    build-essential \
    python3.6 \
    python3-pip \
    python3-dev \
    git && rm -rf /var/lib/apt/lists/*;

RUN pip3 -q --no-cache-dir install pip --upgrade

RUN mkdir -p softwareq/staq/notebooks
WORKDIR softwareq/staq
COPY . .


RUN pip3 install --no-cache-dir jupyter
RUN pip3 install --no-cache-dir git+https://github.com/softwareqinc/staq

WORKDIR /src/notebooks

CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
