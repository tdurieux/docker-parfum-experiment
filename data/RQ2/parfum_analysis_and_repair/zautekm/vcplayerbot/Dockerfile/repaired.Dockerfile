FROM nikolaik/python-nodejs:python3.9-nodejs16

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /requirements.txt
RUN cd /
RUN pip3 install --no-cache-dir -U pip && pip3 install --no-cache-dir -U -r requirements.txt
RUN mkdir /VCPlayerBot
WORKDIR /VCPlayerBot
COPY start.sh /start.sh
CMD ["/bin/bash", "/start.sh"]
