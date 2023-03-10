# Build a docker image
# Merging the ray engine (https://docs.ray.io/en/master/installation.html)
# and DALiuGE
FROM rayproject/ray:74cbf0-py38

#FROM kernsuite/base:7
RUN sudo apt update && sudo apt install --no-install-recommends -y gcc && test -e daliuge || cd && git clone --branch YAN-708 https://github.com/ICRAR/daliuge.git && rm -rf /var/lib/apt/lists/*;
RUN cd /home/ray/daliuge/daliuge-common && pip install --no-cache-dir . \
    && cd ../daliuge-engine && pip install --no-cache-dir . \
    && pip install --no-cache-dir ray \
    && rm -rf /home/ray/anaconda3/lib/python3.7/site-packages/azure \
    && sudo apt-get remove cmake gcc -y \
    && sudo apt-get clean

CMD ["dlg", "daemon", "-vv", "--no-nm"]