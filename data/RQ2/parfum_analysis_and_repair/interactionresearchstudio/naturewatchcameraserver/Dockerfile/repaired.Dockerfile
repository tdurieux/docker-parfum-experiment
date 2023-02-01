FROM sgtwilko/rpi-raspbian-opencv:stretch-latest

# Install python dependencies
COPY requirements-pi.txt .
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements-pi.txt
RUN apt-get update && apt-get install --no-install-recommends -y gpac && rm -rf /var/lib/apt/lists/*;

# Bundle source
COPY naturewatch_camera_server naturewatch_camera_server

# Expose port
EXPOSE 5000

# Run
CMD ["python3", "-m", "naturewatch_camera_server"]
