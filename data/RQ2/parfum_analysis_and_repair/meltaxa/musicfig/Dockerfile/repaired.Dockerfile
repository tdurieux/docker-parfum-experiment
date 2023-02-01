FROM python:3.9-slim

WORKDIR /musicfig
COPY . /musicfig/

RUN apt-get update && \
    apt-get -y --no-install-recommends install python3-usb mpg123 && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir --upgrade pip wheel && pip3 install --no-cache-dir --upgrade -r requirements.txt

ENV PYTHONPATH="/config:$PYTHONPATH"

CMD ["python3", "run.py"]
