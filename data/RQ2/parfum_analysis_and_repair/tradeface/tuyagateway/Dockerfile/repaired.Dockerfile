FROM python:3.6
WORKDIR /usr/src/app
RUN pip install --no-cache-dir tuyagateway
CMD ["tuyagateway"]