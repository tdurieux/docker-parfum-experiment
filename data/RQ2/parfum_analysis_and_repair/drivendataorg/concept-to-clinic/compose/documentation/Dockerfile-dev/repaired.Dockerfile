FROM concepttoclinic_base

RUN apt-get install -y --no-install-recommends make && rm -rf /var/lib/apt/lists/*;

WORKDIR /app
