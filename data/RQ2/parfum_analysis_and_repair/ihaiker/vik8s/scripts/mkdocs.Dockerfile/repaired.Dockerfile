FROM python:3
RUN pip install --no-cache-dir mkdocs && pip install --no-cache-dir mkdocs-ivory

WORKDIR /build

ENTRYPOINT ["mkdocs"]
CMD ["build"]
