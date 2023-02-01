FROM pwntools/pwntools:stable

USER root
RUN pip install --no-cache-dir --upgrade git+https://github.com/Gallopsled/pwntools@dev
RUN pip3 install --no-cache-dir --upgrade git+https://github.com/Gallopsled/pwntools@dev
RUN PWNLIB_NOTERM=1 pwn update
USER pwntools
