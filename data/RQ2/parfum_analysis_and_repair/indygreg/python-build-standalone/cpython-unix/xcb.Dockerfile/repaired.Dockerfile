{% include 'build.Dockerfile' %}
RUN apt-get install -y --no-install-recommends \
    python && rm -rf /var/lib/apt/lists/*;
