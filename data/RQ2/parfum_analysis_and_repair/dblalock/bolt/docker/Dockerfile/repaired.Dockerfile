FROM debian:11.3

RUN apt update -y && apt install --no-install-recommends -y build-essential clang python3 virtualenv git cmake swig libeigen3-dev && rm -rf /var/lib/apt/lists/*;



