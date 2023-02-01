FROM ubuntu

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get --no-install-recommends -y install tzdata && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip libcairo2-dev && rm -rf /var/lib/apt/lists/*;
#libgirepository1.0-dev
RUN apt install --no-install-recommends -y nodejs npm xvfb libgtk2.0-0 libgconf-2-4 libxss1 libnss3-dev libgdk-pixbuf2.0-dev libgtk-3-dev libxss-dev libasound2 && rm -rf /var/lib/apt/lists/*;

RUN npm install electron@6.1.4 orca && npm cache clean --force;

RUN python3 -m pip install --upgrade pip
RUN pip3 install --no-cache-dir wheel

COPY ./requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

WORKDIR /
COPY . /

CMD ["python3", "Bot.py"]

