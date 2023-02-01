RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    unixodbc-dev && \
    pip install --no-cache-dir pyodbc==4.0.30 && rm -rf /var/lib/apt/lists/*;
