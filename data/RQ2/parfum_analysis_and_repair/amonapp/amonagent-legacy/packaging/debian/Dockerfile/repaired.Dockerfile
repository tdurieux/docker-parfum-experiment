FROM ubuntu:latest

RUN apt-get update && apt-get install --no-install-recommends -y gdebi-core && rm -rf /var/lib/apt/lists/*;
ADD AMON_DEB_FILE var/agent.deb

RUN gdebi -n /var/agent.deb

RUN /etc/init.d/amon-agent status

RUN amonpm install boo
RUN amonpm update

CMD ["/bin/bash"]