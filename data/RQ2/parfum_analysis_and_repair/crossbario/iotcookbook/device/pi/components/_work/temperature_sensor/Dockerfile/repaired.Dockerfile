FROM crossbario/autobahn-python-armhf

# install component specific dependencies and remove default content
RUN pip install --no-cache-dir pyopenssl service_identity RPi.GPIO && \
    rm -rf /app/*

# copy the component into the image
COPY ./app /app

# start the component by default
CMD ["python", "-u", "client.py"]
