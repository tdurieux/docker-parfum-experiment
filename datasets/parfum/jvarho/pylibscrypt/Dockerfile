FROM ubuntu:20.04
RUN apt-get update && apt-get install -y python3 python3-pip libpython3-dev libscrypt0 libsodium23 python-openssl libssl-dev
RUN python3 -m pip install coverage hypothesis scrypt
WORKDIR /app
CMD ["./run_docker.sh"]
