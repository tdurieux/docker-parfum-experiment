FROM python:3.10.2-slim
WORKDIR /usr/src/app
COPY . .
RUN apt-get update && apt-get install -y --no-install-recommends libgomp1 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir dendropy
RUN find tools -maxdepth 5 -type f ! -name "*.*" ! -name "README" | xargs -I "{}" chmod +x {}
ENTRYPOINT [ "python3", "magus.py" ]