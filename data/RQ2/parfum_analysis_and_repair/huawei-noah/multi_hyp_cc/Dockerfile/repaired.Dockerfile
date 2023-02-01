FROM nvidia/cuda:10.1-devel-ubuntu18.04

ENV TZ=Europe/London
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get update && apt-get -y --no-install-recommends install tmux python3 python3-pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /tmp
WORKDIR /tmp
RUN pip3 install --no-cache-dir -r requirements.txt

CMD bash
