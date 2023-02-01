FROM ghcr.io/kangershub/torrentleechx:latest

COPY . .

RUN apt-get update -y && apt-get -qq --no-install-recommends install -y mediainfo && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r requirements.txt

RUN chmod +x extract

CMD ["bash","start.sh"]
