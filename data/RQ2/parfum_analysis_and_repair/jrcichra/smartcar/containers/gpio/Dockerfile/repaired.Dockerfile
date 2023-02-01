ARG VERSION=latest
FROM ghcr.io/jrcichra/smartcar_python_base:${VERSION}
COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt
COPY . /
CMD python -u gpio.py