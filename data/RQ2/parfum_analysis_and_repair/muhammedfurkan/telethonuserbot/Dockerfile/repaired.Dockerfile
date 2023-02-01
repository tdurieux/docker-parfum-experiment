FROM ubuntu:latest
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get install --no-install-recommends -y unace unrar zip unzip p7zip-full p7zip-rar sharutils rar && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends python3 git python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get update \
    && apt-get -y --no-install-recommends install libpq-dev gcc \
    && pip install --no-cache-dir psycopg2 \
    && rm -rf /root/.cache/pip/ \
    && find / -name '*.pyc' -delete \
    && find / -name '*__pycache__*' -delete && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U psycopg2-binary
RUN cd /
RUN git clone https://github.com/muhammedfurkan/TelethonUserBot.git
RUN cd TelethonUserBot
WORKDIR /TelethonUserBot
RUN pip3 install --no-cache-dir -r requirements.txt
CMD python3 -m userbot
