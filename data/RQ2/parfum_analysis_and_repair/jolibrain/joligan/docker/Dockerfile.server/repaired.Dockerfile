FROM jolibrain/joligan_build AS joligan_server
WORKDIR /app
CMD ./server/run.sh --host 0.0.0.0 --port 8000
EXPOSE 8000