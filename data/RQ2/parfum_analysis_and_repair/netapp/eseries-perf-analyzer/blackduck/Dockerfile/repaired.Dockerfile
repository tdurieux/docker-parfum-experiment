FROM python:3.10
RUN apt-get update && apt-get install --no-install-recommends -y openjdk-11-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN python -m pip install --upgrade pip
