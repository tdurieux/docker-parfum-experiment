FROM debian:11

RUN apt-get update && \
    apt-get install --no-install-recommends -y build-essential gdb default-jre tmux rsyslog && rm -rf /var/lib/apt/lists/*;

# to see syslogs, run the following in the container
# apt install rsyslog
# service rsyslog start

WORKDIR /instr
