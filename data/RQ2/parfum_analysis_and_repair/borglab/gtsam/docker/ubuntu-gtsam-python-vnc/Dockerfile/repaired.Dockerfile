# This GTSAM image connects to the host X-server via VNC to provide a Graphical User Interface for interaction.

# Get the base Ubuntu/GTSAM image from Docker Hub
FROM borglab/ubuntu-gtsam-python:bionic

# Things needed to get a python GUI
ENV DEBIAN_FRONTEND noninteractive
RUN apt install --no-install-recommends -y python-tk && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install matplotlib

# Install a VNC X-server, Frame buffer, and windows manager
RUN apt install --no-install-recommends -y x11vnc xvfb fluxbox && rm -rf /var/lib/apt/lists/*;

# Finally, install wmctrl needed for bootstrap script
RUN apt install --no-install-recommends -y wmctrl && rm -rf /var/lib/apt/lists/*;

# Copy bootstrap script and make sure it runs
COPY bootstrap.sh /

CMD '/bootstrap.sh'
