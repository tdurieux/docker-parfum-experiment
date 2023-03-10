from python:2.7

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-setuptools \
    python-imaging \
    openssh-server \
    openssh-client \
    x11-xserver-utils \
    sudo && rm -rf /var/lib/apt/lists/*; # Installing dependencies
RUN pip install --no-cache-dir bottle








# Adding pagan user in order to be able to connect through ssh (user: pagan, pass: pagan)
RUN useradd -m pagan && echo "pagan:pagan" | chpasswd && adduser pagan sudo


# Copying files
COPY . .

# Installing pagan
RUN python setup.py install

# Exposing port
EXPOSE 8080

#Starting ssh server and webserver app
CMD service ssh start && python tools/webserver/webserver.py