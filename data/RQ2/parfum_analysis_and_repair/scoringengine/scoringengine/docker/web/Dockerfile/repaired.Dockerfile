FROM scoringengine/base

USER root

# Install curl for docker health check
RUN \
  apt-get update && \
  apt-get install --no-install-recommends -y curl && \
  rm -rf /var/lib/apt/lists/*

USER engine

COPY bin/web /app/bin/web

COPY scoring_engine /app/scoring_engine
RUN pip install --no-cache-dir -e .

CMD ["./wait-for-container.sh", "bootstrap", "uwsgi", "--socket", ":5000", "--wsgi-file", "bin/web", "--master", "--processes", "4", "--threads", "2", "--stats", "0.0.0.0:9191", "--stats-http"]

EXPOSE 5000
