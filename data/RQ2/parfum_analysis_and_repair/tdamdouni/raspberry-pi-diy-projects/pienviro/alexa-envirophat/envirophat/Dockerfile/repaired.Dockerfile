FROM alexellis2/python2-envirophat-armhf:2-dev

RUN pip install --no-cache-dir paho-mqtt
COPY app.py app.py
ENTRYPOINT []
CMD ["python", "app.py"]

