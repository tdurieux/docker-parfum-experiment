FROM python:2.7-slim
WORKDIR /app
ADD . /app
RUN pip install --no-cache-dir flask
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir sklearn

EXPOSE 8082

CMD ["python", "app.py"]
