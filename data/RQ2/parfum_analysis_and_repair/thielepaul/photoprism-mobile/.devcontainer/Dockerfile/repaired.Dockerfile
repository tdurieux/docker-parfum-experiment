FROM cirrusci/flutter:3.0.0
RUN useradd -m flutter -s /bin/bash
RUN adduser flutter sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R flutter:flutter /sdks/flutter
RUN chown -R flutter:flutter /opt/android-sdk-linux
RUN chmod 755 /root
RUN apt update && apt install --no-install-recommends -y libsqlite3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libjsoncpp-dev libsecret-1-dev libgtk-3-dev pkg-config clang ninja-build cmake && rm -rf /var/lib/apt/lists/*;
USER flutter