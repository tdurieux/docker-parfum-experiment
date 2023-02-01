FROM postgres
ENV POSTGRES_USER postgres
ENV POSTGRES_PASSWORD postgres
RUN apt update && apt -y --no-install-recommends install postgis postgresql-13-postgis-3 && rm -rf /var/lib/apt/lists/*;
RUN apt clean