FROM crossbario/autobahn-js-armhf:latest

# install component specific dependencies and remove default content
#RUN pip install pyopenssl service_identity RPi.GPIO && \
#    rm -rf /app/*
RUN apt-get update
RUN apt-get install --no-install-recommends fswebcam -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends sharutils && rm -rf /var/lib/apt/lists/*;
RUN rm -rf /app/*

# copy the component into the image
COPY ./app /app

# start the component by default
# CMD ["node", "client.js"]
