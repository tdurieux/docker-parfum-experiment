FROM python:3.9.6-slim-buster
RUN pip install --no-cache-dir --trusted-host pypi.python.org ochrona
CMD ["python"]