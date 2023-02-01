FROM ubuntu:19.04 as default
WORKDIR /
RUN apt update && apt install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;
RUN apt -y upgrade
COPY script.sh script.sh
RUN chmod +x script.sh
CMD ["bash", "./script.sh"]

FROM default as nginx

