FROM base

RUN dpkg --add-architecture i386 &&  apt-get update && apt-get install --no-install-recommends -y libc6-i386 libstdc++6:i386 && rm -rf /var/lib/apt/lists/*;

ADD zserv*linux26.tgz /
RUN mkdir /zdaemon && mv /zserv*/* /zdaemon/ && chmod +x /zdaemon/zserv
WORKDIR /zdaemon

ADD wads/* /zdaemon/
ADD start-* ffa-template.cfg /zdaemon/

CMD ["./start-ffa.sh"]

