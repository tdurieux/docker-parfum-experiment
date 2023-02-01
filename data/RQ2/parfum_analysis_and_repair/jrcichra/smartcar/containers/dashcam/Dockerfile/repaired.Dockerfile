ARG VERSION=latest
FROM ghcr.io/jrcichra/smartcar_python_base:${VERSION}
COPY requirements.txt /
ENV READTHEDOCS True
RUN pip3 install --no-cache-dir -r /requirements.txt
COPY . /
CMD python3 -u dashcam.py