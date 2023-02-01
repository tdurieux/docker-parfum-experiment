FROM python:3-alpine

RUN pip install --no-cache-dir aiohttp

COPY web.py /

ENTRYPOINT ["python", "web.py"]
