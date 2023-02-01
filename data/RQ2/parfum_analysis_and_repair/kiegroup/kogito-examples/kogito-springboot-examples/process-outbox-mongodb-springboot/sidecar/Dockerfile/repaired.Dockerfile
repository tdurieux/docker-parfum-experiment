FROM mongo:4.4.10

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

COPY launch.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/launch.sh

CMD ["bash", "-c", "/usr/local/bin/launch.sh"]