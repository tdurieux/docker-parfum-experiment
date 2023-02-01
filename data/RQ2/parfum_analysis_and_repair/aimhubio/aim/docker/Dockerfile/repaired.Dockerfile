FROM python:3.9.10-slim

ARG AIM_VERSION
RUN pip install --no-cache-dir Cython==3.0.0a9
RUN pip install --no-cache-dir aim==$AIM_VERSION

WORKDIR /opt/aim
ENTRYPOINT ["aim"]
CMD ["up"]