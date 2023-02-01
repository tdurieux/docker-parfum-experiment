FROM quay.io/azavea/postgis:2.3-postgres9.6-slim

RUN apt-get update
RUN apt-get install --no-install-recommends postgis -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends unzip -y && rm -rf /var/lib/apt/lists/*;
