FROM ubuntu:xenial

run apt-get update && apt-get install --no-install-recommends -y xinetd build-essential gcc-multilib vim-common gdb && rm -rf /var/lib/apt/lists/*;
run apt-get clean

# Add files to container
WORKDIR /opt/cookie
COPY flag /
COPY cookie /opt/cookie/cookie
RUN ls

RUN mkdir -p /var/run/cookie

EXPOSE 53000
CMD ["gdb", "-ex", "run", "./cookie"] 
