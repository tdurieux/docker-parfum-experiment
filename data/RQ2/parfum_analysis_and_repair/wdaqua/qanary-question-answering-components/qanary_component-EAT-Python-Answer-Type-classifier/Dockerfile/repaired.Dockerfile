FROM python:3.6.6-slim

COPY requirements.txt ./

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt; exit 0
RUN pip install --no-cache-dir gunicorn

COPY app app
COPY run.py boot.sh  ./

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN chmod +x boot.sh
ENTRYPOINT ["./boot.sh"]
