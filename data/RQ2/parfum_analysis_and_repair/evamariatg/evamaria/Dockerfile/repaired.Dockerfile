FROM python:3.8-slim-buster

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /requirements.txt

RUN cd /
RUN pip3 install --no-cache-dir -U pip && pip3 install --no-cache-dir -U -r requirements.txt
RUN mkdir /EvaMaria
WORKDIR /EvaMaria
COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
