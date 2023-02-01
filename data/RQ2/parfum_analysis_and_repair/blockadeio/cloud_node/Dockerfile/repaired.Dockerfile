FROM debian

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python-dev libssl-dev mongodb-server build-essential libffi-dev && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

COPY app/api.py /usr/local/bin/api.py

RUN chmod 740 /usr/local/bin/api.py

ENTRYPOINT /usr/local/bin/api.py

EXPOSE 5000
