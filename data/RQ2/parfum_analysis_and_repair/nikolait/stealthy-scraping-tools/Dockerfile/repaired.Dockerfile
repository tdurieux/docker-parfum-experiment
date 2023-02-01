FROM ubuntu:20.04

# Set correct timezone
ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends python3 tesseract-ocr python3-pip curl unzip -yf && rm -rf /var/lib/apt/lists/*;

# Install Chrome
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y dbus-x11 && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

RUN apt-get install --no-install-recommends -y poppler-utils && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y python3-xlib xvfb xserver-xephyr python3-tk python3-dev && rm -rf /var/lib/apt/lists/*;

# https://github.com/puppeteer/puppeteer/issues/5429
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends -y install wget libcairo2-dev \
   libjpeg-dev libpango1.0-dev libgif-dev build-essential g++ libgl1-mesa-dev libxi-dev \
   libx11-dev pulseaudio udev && rm -rf /var/lib/apt/lists/*;

RUN apt update && apt install --no-install-recommends -y postgresql-server-dev-12 && rm -rf /var/lib/apt/lists/*;

RUN curl -f --silent --location https://deb.nodesource.com/setup_14.x | bash - && \
  apt-get -y --no-install-recommends -qq install nodejs && rm -rf /var/lib/apt/lists/*;

# Move this into requirements.txt at some time
RUN pip3 install --no-cache-dir pyautogui python-xlib PyVirtualDisplay

RUN apt-get install --no-install-recommends -y fonts-roboto fonts-ubuntu ttf-bitstream-vera fonts-crosextra-caladea fonts-cantarell fonts-open-sans ttf-wqy-zenhei && rm -rf /var/lib/apt/lists/*;

# install debs error if combine together
RUN apt install -y --no-install-recommends --allow-unauthenticated x11vnc fluxbox xxd \
    && apt autoclean -y \
    && apt autoremove -y \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update -y && apt install --no-install-recommends -y iptables sudo && rm -rf /var/lib/apt/lists/*;

COPY . .

# https://dev.to/emmanuelnk/using-sudo-without-password-prompt-as-non-root-docker-user-52bg
# Create new user `docker` and disable
# password and gecos for later
# --gecos explained well here:
# https://askubuntu.com/a/1195288/635348
RUN adduser --force-badname --disabled-password --gecos '' browserUser

# Add a user to run the browser as non-root
RUN mkdir -p /home/browserUser/Downloads \
  && chown -R browserUser:browserUser /home/browserUser

RUN adduser browserUser sudo

# Ensure sudo group users are not
# asked for a password when using
# sudo command by ammending sudoers file
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> \
/etc/sudoers

RUN chmod 755 start.sh

# Run everything after as non-privileged user.
USER browserUser

# Application specific environment variables
# disp = Display(visible=True, size=(1920, 1080), backend="xvfb", use_xauth=True); disp.start()
# set's DISPLAY=:1
ENV DISPLAY=:1
# By default, only screen 0 exists and has the dimensions 1280x1024x8
ENV XVFB_WHD=1920x1080x24
# x11vnc password
ENV X11VNC_PASSWORD=test
# This variable tells our source code that its invoked within a Docker container
ENV DOCKER=1

ENTRYPOINT [ "./start.sh" ]
