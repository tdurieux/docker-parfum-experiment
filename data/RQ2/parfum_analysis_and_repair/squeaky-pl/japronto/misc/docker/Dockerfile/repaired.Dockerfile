FROM python:3.6.0-slim

RUN pip3 install --no-cache-dir japronto
ENV PYTHONUNBUFFERED=1
ENTRYPOINT ["japronto"]
