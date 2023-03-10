FROM python:3.8

# Install requirements
COPY requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt
RUN apt update && apt install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
ENTRYPOINT ["rq" ,"worker", "high","default", "low" ,"video-tasks" ,"--url" ,"redis://redis-host"]
