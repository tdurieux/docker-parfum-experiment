FROM ubuntu
# run a server on port 8000
RUN apt update && apt install --no-install-recommends -y iproute2 iputils-ping python3 traceroute wget curl && rm -rf /var/lib/apt/lists/*;
COPY local.py local.py
CMD python3 local.py