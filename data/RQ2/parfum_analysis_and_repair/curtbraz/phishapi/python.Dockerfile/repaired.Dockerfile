FROM python:2.7
ENV DEBIAN_FRONTEND=noninteractive

ADD Responder /
CMD [ "python", "./Responder.py", "-I", "eth0", "-wrf"]
RUN apt-get update && apt-get install --no-install-recommends -y mariadb-client && rm -rf /var/lib/apt/lists/*;