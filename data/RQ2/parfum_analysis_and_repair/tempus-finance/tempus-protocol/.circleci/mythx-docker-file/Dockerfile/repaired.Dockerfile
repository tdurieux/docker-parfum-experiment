FROM cimg/node:16.14.0
RUN sudo apt update
RUN sudo apt install -y --no-install-recommends python3-pip && rm -rf /var/lib/apt/lists/*;
RUN sudo pip3 install --no-cache-dir markupsafe==2.0.1
RUN sudo pip3 install --no-cache-dir python-dateutil==2.8.1
RUN sudo pip3 install --no-cache-dir mythx-cli
