FROM danisla/gotty:latest

COPY packages.txt /opt/cloudshell/packages.txt
RUN apt-get update && apt-get install --no-install-recommends -y -q $(grep -vE "^\s*#" /opt/cloudshell/packages.txt  | tr "\n" " ") && rm -rf /var/lib/apt/lists/*;

COPY bootstrap.sh /usr/local/bin/bootstrap.sh
RUN /usr/local/bin/bootstrap.sh

COPY init.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/init.sh

COPY cloudshell_profile /etc/profile.d/cloudshell

ENV UNAME cloudshell
ENV USERID 500
ENV GROUPID 100

ENTRYPOINT ["/usr/local/bin/init.sh"]

CMD ["/gotty","-p", "9000", "-w", "tmux", "new", "-A", "-s", "bash"]