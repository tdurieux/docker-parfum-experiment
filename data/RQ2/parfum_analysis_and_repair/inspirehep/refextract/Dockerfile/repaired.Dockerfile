FROM python:3.8
RUN apt update && apt install --no-install-recommends poppler-utils -y && rm -rf /var/lib/apt/lists/*;
COPY setup.py setup.cfg README.rst ./
COPY refextract refextract/
RUN python setup.py install
ENV PROMETHEUS_MULTIPROC_DIR='/tmp'
ENTRYPOINT exec gunicorn -b :5000 --access-logfile - --error-logfile - refextract.app:app --timeout 650
