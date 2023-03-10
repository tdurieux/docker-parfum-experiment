# Developmental Docker container, performing the same tasks as in .travis.yml
FROM python:3.8

WORKDIR /src
COPY requirements.txt .
RUN pip install --no-cache-dir -U -r requirements.txt

COPY test_requirements.txt .
RUN pip install --no-cache-dir -U -r test_requirements.txt

COPY . .
RUN pip install --no-cache-dir --no-deps -e .
ENTRYPOINT ["pytest", "--cov=src/", "--cov-report", "term-missing", "--cov-report", "term:skip-covered", \
    "--cov-config=tox.ini", "--cov-fail-under=100", "-s", "-r", "."]
CMD ["-r", "."]
