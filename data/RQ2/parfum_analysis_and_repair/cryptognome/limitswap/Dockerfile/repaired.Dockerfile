FROM python:3.10-slim

RUN apt-get update && \
    apt-get install --no-install-recommends -y python3-pip \
    python3-dev && rm -rf /var/lib/apt/lists/*;

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

WORKDIR /app

ADD . /app

RUN useradd --create-home limitswap
USER root
RUN chown limitswap:limitswap -R /app/
USER limitswap

RUN pip install --no-cache-dir --upgrade pip --no-warn-script-location
RUN pip install --no-cache-dir -r requirements.txt --no-warn-script-location

CMD ["python", "LimitSwap.py"]
