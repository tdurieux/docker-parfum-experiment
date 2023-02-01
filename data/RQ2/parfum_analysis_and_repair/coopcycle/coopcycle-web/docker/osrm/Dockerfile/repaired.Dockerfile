FROM osrm/osrm-backend:v5.23.0

RUN apt-get update && apt-get install --no-install-recommends -y openssl wget && rm -rf /var/lib/apt/lists/*;

COPY ./start.sh /usr/local/bin/osrm-start

RUN chmod +x /usr/local/bin/osrm-start

CMD ["osrm-start"]
