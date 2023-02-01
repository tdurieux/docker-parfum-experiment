FROM python:3.6-alpine3.9

# Install dependencies
RUN pip3 install --no-cache-dir paho-mqtt

# Copy script
COPY drone /drone

# Expose command
CMD python /drone/drone.py