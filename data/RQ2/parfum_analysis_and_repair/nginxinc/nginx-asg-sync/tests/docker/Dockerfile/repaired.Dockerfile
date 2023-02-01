FROM python:3.7.2-slim

RUN mkdir /workspace

WORKDIR /workspace

COPY tests tests

WORKDIR /workspace/tests

RUN pip install --no-cache-dir -r requirements.txt

ENTRYPOINT [ "python3", "-m", "pytest"]