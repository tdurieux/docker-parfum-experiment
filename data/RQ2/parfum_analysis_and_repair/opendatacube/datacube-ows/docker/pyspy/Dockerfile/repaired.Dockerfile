# pyspy/Dockerfile
FROM python:3.6
RUN pip install --no-cache-dir py-spy
WORKDIR /profiles
ENTRYPOINT [ "py-spy" ]
CMD []