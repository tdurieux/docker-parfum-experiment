FROM ubuntu
RUN apt-get update && apt-get install -y --no-install-recommends stress && rm -rf /var/lib/apt/lists/*;
CMD stress $var
