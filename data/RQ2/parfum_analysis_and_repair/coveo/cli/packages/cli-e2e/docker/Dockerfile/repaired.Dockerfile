FROM node:lts-buster

RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
RUN apt-get update

RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --set x-www-browser /usr/bin/google-chrome-stable

# Brew, used for mitmproxy
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

RUN apt-get install -y --no-install-recommends git && rm -rf /var/lib/apt/lists/*;

# Keyring deps
RUN apt-get install --no-install-recommends -y dbus-x11 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gnome-keyring && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -yq libgconf-2-4 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y make build-essential libssl-dev zlib1g-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libncurses5-dev libncursesw5-dev xz-utils tk-dev && rm -rf /var/lib/apt/lists/*;

# For headless without headless.
RUN apt-get install --no-install-recommends xvfb -y && rm -rf /var/lib/apt/lists/*;

# cp but better (need filtering abilities)
RUN apt-get install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
# sudo for running the test as not root while still being root.
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

# Add user so we don't need --no-sandbox.
RUN addgroup --system notGroot --force-badname && adduser --system --group notGroot --force-badname \
    && mkdir -p /home/notGroot/Downloads /app

# Setup the keyring.
RUN mkdir -p /home/notGroot/.local/share/keyrings
RUN touch /home/notGroot/.local/share/keyrings/Default_keyring.keyring


RUN printf '[keyring]\n\
display-name=Default keyring\n\
ctime=1614975180\n\
mtime=0\n\
lock-on-idle=false\n\
lock-after=false\n' > /home/notGroot/.local/share/keyrings/Default_keyring.keyring

RUN printf 'Default_keyring' > /home/notGroot/.local/share/keyrings/default

# Give the file access to the test user.
RUN chown -R notGroot:notGroot /home/notGroot \
    && chmod -R 777 /home/notGroot/ \
    && chmod -R 777 /usr/ \
    && chown -R notGroot:notGroot /app \
    && chmod -R 600 /home/notGroot/.local/share/keyrings/Default_keyring.keyring \
    && chmod -R 644 /home/notGroot/.local/share/keyrings/default

# Ensure root pwd is set to something known
RUN echo 'root:Docker!' | chpasswd
RUN echo 'notGroot:Docker!' | chpasswd
RUN usermod -aG sudo notGroot
# Run everything after as non-privileged user.
USER notGroot

RUN git config --global user.name "notgroot"
RUN git config --global user.email "notgroot@coveo.com"