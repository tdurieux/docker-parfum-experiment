# Use an official Python runtime as a parent image
FROM python:3.6-slim

RUN pip install --no-cache-dir numpy scipy pandas matplotlib

# entrypoint to pyhon directly
ENTRYPOINT ["/usr/local/bin/python"]
