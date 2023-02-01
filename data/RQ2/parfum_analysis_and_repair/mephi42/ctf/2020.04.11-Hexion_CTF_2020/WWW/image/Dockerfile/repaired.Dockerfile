FROM ubuntu:18.04
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install python3 python3-pip python3-dev git libssl-dev libffi-dev build-essential && rm -rf /var/lib/apt/lists/*;
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade git+https://github.com/Gallopsled/pwntools.git@dev
RUN apt-get -y --no-install-recommends install gdb && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install xterm && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/pwndbg/pwndbg && cd pwndbg && ./setup.sh
