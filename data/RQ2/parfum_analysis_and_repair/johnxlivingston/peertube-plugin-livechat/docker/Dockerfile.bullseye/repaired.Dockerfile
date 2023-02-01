FROM chocobozzz/peertube:production-bullseye

RUN apt -y update && apt install --no-install-recommends -y prosody && apt -y clean && rm -rf /var/lib/apt/lists/*;
