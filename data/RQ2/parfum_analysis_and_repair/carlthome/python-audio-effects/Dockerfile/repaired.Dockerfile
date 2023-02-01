# This container is for developing locally inside it.
FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir librosa
COPY . .
RUN pip install --no-cache-dir -e .[test]