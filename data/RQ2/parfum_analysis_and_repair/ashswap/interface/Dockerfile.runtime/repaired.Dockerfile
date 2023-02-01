FROM node:14.18.0
RUN apt update && apt-get install --no-install-recommends -y libusb-1.0-0-dev && rm -rf /var/lib/apt/lists/*;