FROM python:3.6.6-stretch

COPY requirements-dev.txt requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-dev.txt
RUN pip install --no-cache-dir -q pytest==3.9.3 awscli pytest-benchmark feather-format lxml openpyxl xlrd numpy matplotlib sqlalchemy

COPY . .
RUN pip install --no-cache-dir -e .

ENTRYPOINT ["bash", ".jenkins/performance-tests/run_perf_test.sh"]
