FROM python:3.7.3-slim

RUN pip install --no-cache-dir kafka-python
RUN pip install --no-cache-dir flask

ADD /util/* /util/
ADD python_router_app.py /
ENTRYPOINT ["python","/python_router_app.py"]
CMD []
