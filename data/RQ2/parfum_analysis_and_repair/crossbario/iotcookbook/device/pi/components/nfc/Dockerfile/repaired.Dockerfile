FROM crossbario/autobahn-python-armhf

# install component specific dependencies
RUN pip install --no-cache-dir pyopenssl service_identity RPi.GPIO Adafruit_GPIO

# copy the component into the image
RUN rm -rf /app/*
COPY ./app /app

# start the component by default
CMD ["python", "-u", "client.py"]
