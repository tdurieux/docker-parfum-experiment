FROM python:3.9.7-slim

COPY ./app /app

RUN apt-get update && \
    apt-get install --no-install-recommends -y locales git && \
    sed -i -e 's/# fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    rm -rf /var/lib/apt/lists/*

ENV LANG fr_FR.UTF-8
ENV LC_ALL fr_FR.UTF-8
ENV TZ=Europe/Paris

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r /app/requirement.txt
RUN pip install --no-cache-dir git+https://github.com/influxdata/influxdb-client-python.git@master

CMD ["python", "-u", "/app/main.py"]
