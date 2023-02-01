FROM arm32v7/debian

RUN apt-get update && apt-get install --no-install-recommends -my wget gnupg curl git apt-transport-https gcc cmake && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT tail -f /dev/null
