FROM busybox:1.0
RUN apt-get install -y --no-install-recommends curl && rm -rf /var/lib/apt/lists/*;
HEALTHCHECK CMD curl --fail http://localhost:3000 || exit 1