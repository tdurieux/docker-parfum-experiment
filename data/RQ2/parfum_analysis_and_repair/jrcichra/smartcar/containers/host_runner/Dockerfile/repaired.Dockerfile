ARG VERSION=latest
FROM ghcr.io/jrcichra/smartcar_python_base:${VERSION}
EXPOSE 8080
COPY requirements.txt /
RUN pip3 install --no-cache-dir -r /requirements.txt
COPY . /
CMD python -u host_runner.py
