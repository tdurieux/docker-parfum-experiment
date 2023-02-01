FROM jinaai/jina:2.6.2-py39-standard

# setup the workspace
COPY . /workspace
WORKDIR /workspace

RUN apt-get update && apt-get install --no-install-recommends -y git build-essential g++\
    && pip install -r requirements.txt

ENTRYPOINT ["python", "app.py", "-t", "search"]

EXPOSE 45678
