FROM python:3.7-slim
RUN pip install --no-cache-dir --trusted-host pypi.python.org pyraider
CMD ["python"]