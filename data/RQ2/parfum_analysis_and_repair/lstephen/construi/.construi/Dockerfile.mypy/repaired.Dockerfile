FROM python:3.7
RUN pip install --no-cache-dir mypy
ENTRYPOINT ["mypy"]
