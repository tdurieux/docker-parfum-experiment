FROM python:3-alpine
WORKDIR /usr/src
COPY requirements-tracker.txt .
RUN pip3 install --no-cache-dir -r requirements-tracker.txt
COPY . .
ENTRYPOINT ["python3", "-m", "terroroftinytown.tracker", "tracker_docker.conf"]
