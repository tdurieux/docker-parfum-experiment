FROM crossbario/autobahn-python-armhf

# install component specific dependencies and remove default content
RUN apt-get update && \
    apt-get install --no-install-recommends -y libsdl-dev && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pyopenssl service_identity

RUN pip install --no-cache-dir python-rtmidi

RUN rm -rf /app/*

# copy the component into the image
COPY ./app /app

# start the component by default
CMD ["python", "-u", "client.py"]
