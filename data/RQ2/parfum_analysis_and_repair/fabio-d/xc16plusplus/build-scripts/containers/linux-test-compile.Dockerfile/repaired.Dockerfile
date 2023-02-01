FROM ubuntu:18.04

# Install prerequisites
RUN dpkg --add-architecture i386 && apt update && apt install --no-install-recommends -y libexpat1 libexpat1:i386 python3 xz-utils libstdc++6:i386 make && rm -rf /var/lib/apt/lists/*;

# Make it possible to install the compiler here as a non-root user
RUN chmod 777 /opt
