FROM ubuntu:21.04
WORKDIR /home/trader/mmr
ENV container docker
ENV PATH "/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive

# RUN useradd -rm -d /home/trader -s /bin/bash -g root -G sudo -u 1000 trader
RUN useradd -m -d /home/trader -s /bin/bash -G sudo trader
RUN mkdir -p /var/run/sshd
RUN mkdir -p /run/sshd
RUN mkdir -p /tmp
RUN apt-get update
RUN apt-get install --no-install-recommends -y dialog apt-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y dpkg && rm -rf /var/lib/apt/lists/*;

# set to New York timezone, can override with docker run -e TZ=Europe/London etc.
ENV TZ=America/New_York
RUN apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# mongo
RUN wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | apt-key add -
RUN echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | tee /etc/apt/sources.list.d/mongodb-org-5.0.list
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y mongodb-org && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y linux-headers-generic && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lzip curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openssh-server sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y tmux && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y expect && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iproute2 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y net-tools && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y iputils-ping && rm -rf /var/lib/apt/lists/*;
# required for pyenv to build 3.9.5 properly
RUN apt-get install --no-install-recommends -y libbz2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libreadline-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-venv && rm -rf /var/lib/apt/lists/*;

RUN echo 'trader:trader' | chpasswd
RUN service ssh start

# ports
# ssh
EXPOSE 22
# tws
EXPOSE 7496
# redis
EXPOSE 6379
# mongo/arctic
EXPOSE 27017
# pycron
EXPOSE 8081
# vnc
EXPOSE 5900
EXPOSE 5901

# copy over the source and data
COPY ./ /home/trader/mmr/

# spin up the directories required
RUN mkdir /home/trader/ibc
RUN mkdir /home/trader/ibc/logs
# RUN mkdir /home/trader/mmr/data
RUN mkdir /home/trader/mmr/data/redis
RUN mkdir /home/trader/mmr/data/mongodb
RUN mkdir /home/trader/mmr/logs

# install IBC
RUN wget https://github.com/IbcAlpha/IBC/releases/download/3.13.0/IBCLinux-3.13.0.zip -P /home/trader
RUN unzip /home/trader/IBCLinux-3.13.0.zip -d /home/trader/ibc
RUN rm /home/trader/IBCLinux-3.13.0.zip
RUN chmod +x /home/trader/ibc/*.sh

# download TWS offline installer
RUN wget https://download2.interactivebrokers.com/installers/tws/latest-standalone/tws-latest-standalone-linux-x64.sh -P /home/trader
RUN chmod +x /home/trader/tws-latest-standalone-linux-x64.sh
RUN chmod +x /home/trader/mmr/scripts/installation/install_tws.sh

# TWS needs JavaFX to be able to fully start
RUN apt-get install --no-install-recommends -y openjfx && rm -rf /var/lib/apt/lists/*;

# pip install packages
RUN --mount=type=cache,target=/root/.cache \
   pip3 install --no-cache-dir -r /home/trader/mmr/requirements.txt

# install window managers, Xvfb and vnc
RUN apt-get install --no-install-recommends -y tigervnc-scraping-server && rm -rf /var/lib/apt/lists/*;
# RUN apt-get install -y awesome
RUN apt-get install --no-install-recommends -y python3-cairocffi && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xterm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y language-pack-en-base && rm -rf /var/lib/apt/lists/*;

RUN mkdir /home/trader/.vnc
RUN echo 'trader' | vncpasswd -f > /home/trader/.vnc/passwd

RUN mkdir /home/trader/.config
# RUN mkdir /home/trader/.config/awesome
RUN mkdir /home/trader/.config/qtile

COPY ./scripts/installation/.bash_profile /home/trader
COPY ./scripts/installation/start_trader.sh /home/trader
COPY ./scripts/installation/twsstart.sh /home/trader/ibc/twsstart.sh
COPY ./scripts/installation/config.ini /home/trader/ibc/config.ini
COPY ./scripts/installation/config.py /home/trader/.configs/qtile

RUN --mount=type=cache,target=/root/.cache \
   pip3 install --no-cache-dir qtile

# data needs to be copied manually?
# COPY ./data/ib_symbols_nyse_nasdaq.csv /home/trader/mmr/data/ib_symbols_nyse_nasdaq.csv
# COPY ./data/symbols_historical.csv /home/trader/mmr/data/symbols_historical.csv

RUN chown -R trader:trader /home/trader
WORKDIR /home/trader

#ENTRYPOINT /home/trader/mmr/scripts/docker_startup.sh
#CMD tail -f /dev/null
ENTRYPOINT service ssh restart && tail -f /dev/null
