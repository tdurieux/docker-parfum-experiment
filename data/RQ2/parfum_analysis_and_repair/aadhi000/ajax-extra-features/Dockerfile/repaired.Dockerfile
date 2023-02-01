FROM python:3.10-slim-buster

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends git -y && rm -rf /var/lib/apt/lists/*;
COPY requirements.txt /requirements.txt

RUN cd /
RUN pip3 install --no-cache-dir -U pip && pip3 install --no-cache-dir -U -r requirements.txt
RUN mkdir /Ajax-Extra-Features
WORKDIR /Ajax-Extra-Features
COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
