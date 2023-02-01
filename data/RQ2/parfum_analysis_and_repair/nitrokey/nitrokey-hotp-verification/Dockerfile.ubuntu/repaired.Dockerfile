FROM ubuntu:18.04
RUN apt update
RUN apt -y --no-install-recommends install disorderfs faketime locales-all sudo util-linux cmake make gcc && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install python3 reprotest && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install build-essential zlib1g-dev uuid-dev libdigest-sha-perl libelf-dev bc bzip2 bison flex git gnupg iasl m4 nasm patch python wget gnat cpio ccache pkg-config cmake libusb-1.0-0-dev autoconf && rm -rf /var/lib/apt/lists/*;
RUN apt -y --no-install-recommends install libhidapi-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
