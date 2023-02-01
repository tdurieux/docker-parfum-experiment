FROM python:3-alpine
RUN pip install --no-cache-dir click
COPY . .
ENTRYPOINT ["python", "shipyard.py"]
