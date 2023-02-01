FROM ubuntu
RUN apt update -y && \
 apt install --no-install-recommends netcat net-tools nmap iproute2 -y && rm -rf /var/lib/apt/lists/*;
EXPOSE 4444
