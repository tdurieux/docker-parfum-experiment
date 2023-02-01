FROM python:3-onbuild

WORKDIR .
RUN apt-get update && apt-get install --no-install-recommends -y \
    sqlite3 \
    libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip setuptools wheel
RUN pip3 install --no-cache-dir -e .
RUN echo "django-x509 Installed"
WORKDIR tests/
CMD ["./docker-entrypoint.sh"]
EXPOSE 8000

ENV NAME djangox509
