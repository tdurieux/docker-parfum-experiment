FROM linuxserver/calibre:latest

WORKDIR /Processed_By

RUN apt-get -y update \
  && apt -y --no-install-recommends install python3-pip \
  && pip3 install --no-cache-dir hachoir \
  && pip3 install --no-cache-dir pyrogram \
  && pip3 install --no-cache-dir tgcrypto \
  && pip3 install --no-cache-dir python-dotenv && rm -rf /var/lib/apt/lists/*;

COPY . .

CMD ["bash","start.sh"]