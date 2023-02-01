FROM python:3.8
RUN apt-get update -y && apt-get install --no-install-recommends -y tcpdump nmap iputils-ping libpq-dev python3-psycopg2 lsof psmisc dnsutils curl ftp smbclient ssh telnet xtightvncviewer xvfb && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir honeypots==0.28
WORKDIR app
COPY config.json .
COPY testing.sh .
RUN ["chmod","+x","testing.sh"]
