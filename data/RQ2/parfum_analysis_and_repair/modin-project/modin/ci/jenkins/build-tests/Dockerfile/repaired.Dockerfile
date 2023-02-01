FROM python:3.6.6-stretch

COPY requirements-dev.txt requirements-dev.txt
RUN pip install --no-cache-dir -r requirements-dev.txt

COPY . .
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir awscli pytest-html

ENTRYPOINT ["bash", ".jenkins/build-tests/run_test.sh"]
