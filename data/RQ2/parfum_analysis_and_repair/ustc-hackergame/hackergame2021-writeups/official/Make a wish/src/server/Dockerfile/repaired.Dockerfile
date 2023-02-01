# run with -it
FROM ubuntu:20.04
RUN apt update && apt install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN useradd hacker -d /home/hacker -m
COPY files/nethackrc /home/hacker/.nethackrc
RUN chmod 666 /home/hacker/.nethackrc
COPY files/nethack-3.4.3-bin-hg.tar.gz /nh343.tar.gz
RUN tar xf /nh343.tar.gz -C / && rm /nh343.tar.gz
ENTRYPOINT ["su", "hacker", "-c", "export TERM=xterm-256color; script /dev/null -c nethack"]
