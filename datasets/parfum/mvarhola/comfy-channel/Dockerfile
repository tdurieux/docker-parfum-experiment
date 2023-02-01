FROM jrottenberg/ffmpeg:3.3-alpine

# Get host instance IP
ENV SERVER_IP="host.docker.internal"

# Install Python3 and Pip
# from frolvlad/alpine-python3
RUN apk add --no-cache git python3 py-psutil libmediainfo tzdata && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache

# Set system time to Chicago Time (can be changed)
RUN cp /usr/share/zoneinfo/America/Chicago /etc/localtime

# Set the working directory
WORKDIR /comfy-channel

# Clone the comfy-channel git repo
ADD src /comfy-channel/src/
ADD upnext /comfy-channel/upnext/
ADD fonts /comfy-channel/fonts/
ADD playout.ini /comfy-channel/

RUN ls

# Install any needed packages specified in requirements.txt
RUN pip install --trusted-host pypi.python.org -r /comfy-channel/src/requirements.txt

# Reset the entry point from jrottenberg/ffmpeg
ENTRYPOINT []

# Expose RTMP port
EXPOSE 1935

# Run ComfyChannel.py when the container launches
#CMD ["python","-u","src/ComfyChannel.py", "-o", "echo ${output_location}"]
CMD python -u src/ComfyChannel.py -o "rtmp://"${SERVER_IP}