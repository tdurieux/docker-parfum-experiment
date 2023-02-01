FROM flask_service:python-3.10-slim-bullseye

ADD requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -qr /tmp/requirements.txt
