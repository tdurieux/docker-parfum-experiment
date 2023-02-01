FROM pwntools/pwntools:base

USER root
RUN pip install --no-cache-dir --upgrade git+https://github.com/Gallopsled/pwntools@stable
RUN pip3 install --no-cache-dir --upgrade git+https://github.com/Gallopsled/pwntools@stable
RUN PWNLIB_NOTERM=1 pwn update
USER pwntools
