FROM crossbario/autobahn-python-armhf

# install component specific dependencies and remove default content
RUN apt-get update && \
    apt-get install --no-install-recommends -y xboxdrv && \
    pip install --no-cache-dir pyopenssl service_identity && \
    rm -rf /app/* && rm -rf /var/lib/apt/lists/*;

# copy the component into the image
COPY ./app /app

# start the component by default
CMD ["/app/run"]
