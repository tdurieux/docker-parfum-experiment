FROM node
RUN apt update && apt install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;
COPY entrypoint.sh /entrypoint.sh
CMD /entrypoint.sh
