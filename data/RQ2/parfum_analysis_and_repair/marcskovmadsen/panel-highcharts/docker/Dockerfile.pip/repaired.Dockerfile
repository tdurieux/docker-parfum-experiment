FROM python:3.8.9-slim-buster

RUN pip install --no-cache-dir pip --upgrade
RUN pip install --no-cache-dir panel-highcharts

ENTRYPOINT ["bash"]