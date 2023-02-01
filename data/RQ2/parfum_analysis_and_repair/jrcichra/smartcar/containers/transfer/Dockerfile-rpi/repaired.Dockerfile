ARG VERSION=latest
FROM ghcr.io/jrcichra/smartcar_python_base_rpi:${VERSION}
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
COPY . /
CMD python3 -u transfer.py
