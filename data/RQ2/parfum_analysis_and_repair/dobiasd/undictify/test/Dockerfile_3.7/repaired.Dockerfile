FROM python:3.7

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir pylint mypy
