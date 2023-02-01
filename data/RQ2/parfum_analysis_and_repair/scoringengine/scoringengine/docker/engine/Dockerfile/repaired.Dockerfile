FROM scoringengine/base

COPY bin/engine /app/bin/engine

COPY scoring_engine /app/scoring_engine
RUN pip install --no-cache-dir -e .

CMD ["./wait-for-container.sh", "bootstrap", "/app/bin/engine"]
