FROM ubuntu
RUN apt-get update && \
    apt-get full-upgrade -y && \
    apt-get install --no-install-recommends python3 -y && \
    apt-get install --no-install-recommends python3-pip -y && \
    apt-get install --no-install-recommends tmux -y && \
    apt-get install --no-install-recommends openjdk-13-jre-headless -y && \
    apt-get install --no-install-recommends zip -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir discord.py lavalink python-dotenv psutil && \
    apt-get remove python3-pip -y

COPY ./Bot /MusicBot

RUN groupadd -g 1000 basicuser && useradd -r -u 1000 -g basicuser basicuser

USER basicuser