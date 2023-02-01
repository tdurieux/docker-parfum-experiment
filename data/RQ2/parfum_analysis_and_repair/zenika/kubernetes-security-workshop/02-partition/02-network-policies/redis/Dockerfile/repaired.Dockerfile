FROM redis:5

RUN apt update && apt install --no-install-recommends -y curl=7.64.0-4 netcat=1.10-41.1 && rm -rf /var/lib/apt/lists/*;

