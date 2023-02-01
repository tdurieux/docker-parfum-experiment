FROM python:3.8-slim

RUN apt-get update -y && apt-get install --no-install-recommends -y \
  build-essential \
  pkg-config && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir gunicorn

COPY flask/avogadro/requirements.txt /app/
RUN pip3 install --no-cache-dir -r /app/requirements.txt

COPY flask/avogadro/src/* /app/

WORKDIR /app

ENTRYPOINT ["gunicorn", "-w",  "4", "-t", "600", "server:app", "-b", "0.0.0.0:5001"]
