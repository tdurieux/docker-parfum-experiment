FROM python:2.7
RUN pip install --no-cache-dir pip-tools
ENTRYPOINT ["pip-compile"]
