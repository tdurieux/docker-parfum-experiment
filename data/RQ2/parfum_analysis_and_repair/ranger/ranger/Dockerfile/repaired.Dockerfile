# Usage instructions:
# 1. "docker build -t ranger/ranger:latest ."
# 2. "docker run -it ranger/ranger"

FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y ranger && rm -rf /var/lib/apt/lists/*;
ENTRYPOINT ["ranger"]
