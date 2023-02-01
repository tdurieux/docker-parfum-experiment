FROM python:3.7
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
WORKDIR /workspace
COPY . .
RUN pip install --no-cache-dir -e .
