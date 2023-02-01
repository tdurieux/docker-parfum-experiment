FROM python:3.8.2-slim

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install --no-install-recommends git apt-utils -y && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/treescience/search.tree.science
WORKDIR search.tree.science
ENTRYPOINT ["python", "-m", "http.server", "8080"]
