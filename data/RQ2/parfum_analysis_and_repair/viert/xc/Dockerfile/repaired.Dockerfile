FROM golang:1.15
RUN apt update && apt install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir mailru-im-bot
ADD icqnotify.py /bin/icqnotify.py
