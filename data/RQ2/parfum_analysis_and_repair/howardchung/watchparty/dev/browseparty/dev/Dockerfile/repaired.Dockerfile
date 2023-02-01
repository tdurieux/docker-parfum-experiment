FROM ubuntu:xenial

RUN apt-get update; apt-get clean

# Add a user for running applications.
RUN useradd apps
RUN mkdir -p /home/apps && chown apps:apps /home/apps

# Install x11vnc.
RUN apt-get install --no-install-recommends -y x11vnc && rm -rf /var/lib/apt/lists/*;

# Install xvfb.
RUN apt-get install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;

# Install fluxbox.
RUN apt-get install --no-install-recommends -y fluxbox && rm -rf /var/lib/apt/lists/*;

# Install wget.
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Install wmctrl.
RUN apt-get install --no-install-recommends -y wmctrl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y gnupg2 && rm -rf /var/lib/apt/lists/*;

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y --no-install-recommends install google-chrome-stable && rm -rf /var/lib/apt/lists/*;

COPY bootstrap.sh /

CMD '/bootstrap.sh'