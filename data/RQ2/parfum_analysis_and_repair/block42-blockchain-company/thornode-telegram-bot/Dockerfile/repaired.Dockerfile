FROM ubuntu:18.04

ADD . /

RUN apt-get update
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.7 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3.7-dev && rm -rf /var/lib/apt/lists/*;
RUN python3.7 -m pip install pip

RUN python3.7 -m pip install -r requirements.txt

CMD [ "python3.7", "bot/thornode_bot.py" ]
