FROM ubuntu:18.04
# Run this to build this image:
# source scripts/common.sh && docker build -t $BUILD_IMAGE .

LABEL maintainer="ulauncher.app@gmail.com"

# NOTE: Keep lines separate. One "RUN" per dependency/change
# https://stackoverflow.com/a/47451019/633921

WORKDIR /root/ulauncher

RUN apt update
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y tzdata && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y keyboard-configuration && rm -rf /var/lib/apt/lists/*;

# Build and test dependencies
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y rsync && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y xvfb && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y dput && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y debhelper && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y dh-python && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --upgrade setuptools
RUN wget -qO- https://deb.nodesource.com/setup_12.x | bash -
RUN apt install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install -g yarn && npm cache clean --force;

# App dependencies
RUN apt install --no-install-recommends -y python3-all && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-levenshtein && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-gi && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-glib-2.0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-gtk-3.0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-wnck-3.0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-notify-0.7 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-webkit2-4.0 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y gir1.2-keybinder-3.0 && rm -rf /var/lib/apt/lists/*;

# Upgrade python3-gi on 18.04 (skip this section if you upgrade the Dockerfile to 20.04+)
RUN apt install --no-install-recommends -y libgirepository1.0-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libcairo2-dev && rm -rf /var/lib/apt/lists/*;
RUN apt remove -y python3-gi
RUN pip3 install --no-cache-dir --upgrade PyGObject

# Clean up
RUN apt autoremove -y
RUN apt clean

COPY [ "requirements.txt", "preferences-src/package.json", "./" ]
COPY [ "docs/requirements.txt", "./docs/" ]

# Update /etc/dput.cf to use sftp for upload to ppa.launchpad.net
COPY [ "scripts/dput.cf", "/etc" ]

RUN pip3 install --no-cache-dir -r requirements.txt
RUN pip3 install --no-cache-dir -r docs/requirements.txt
# Caching node_modules to make builds faster
RUN yarn
RUN mv node_modules /var
