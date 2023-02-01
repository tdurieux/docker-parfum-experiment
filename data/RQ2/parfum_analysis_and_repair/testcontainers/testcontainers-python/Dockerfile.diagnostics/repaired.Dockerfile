ARG version=3.8
FROM python:${version}

WORKDIR /workspace
COPY setup.py README.rst ./
RUN pip install --no-cache-dir -e .
COPY . .
