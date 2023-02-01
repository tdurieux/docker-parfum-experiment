FROM python:3.7-slim as runtime
COPY pip.conf /etc/pip.conf
RUN pip3 install --no-cache-dir awscrt
RUN pip3 install --no-cache-dir awsiotsdk
RUN pip3 install --no-cache-dir Flask
RUN pip3 install --no-cache-dir future
COPY . /app
WORKDIR /app

ENTRYPOINT ["python"]
CMD ["app.py"]