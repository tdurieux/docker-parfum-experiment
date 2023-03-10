FROM ubuntu:18.04

RUN apt-get update
RUN apt-get upgrade -y
RUN set -e -x; \
        groupadd -g 1337 user; \
        useradd -g 1337 -u 1337 -m user

RUN apt-get install --no-install-recommends -y python3 python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir virtualenv
RUN apt-get install --no-install-recommends -y gdbserver && rm -rf /var/lib/apt/lists/*;

RUN virtualenv /env -p python3

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH
ENV TRIAL_KEY=yeep8auGezo4aic6aezo

ADD web_challenge/challenge/requirements.txt /home/user/
ADD web_challenge/challenge/gunicorn.conf.py /home/user/
ADD web_challenge/challenge/gaas.py /home/user/
ADD web_challenge/challenge/gdbproc.py /home/user/
ADD web_challenge/challenge/index.html /home/user/
ADD web_challenge/challenge/flag /home/user/

RUN set -e -x; \
        chown -R root:root /home/user; \
        chmod 0555 /home/user/gunicorn.conf.py; \
        chmod 0555 /home/user/gaas.py; \
        chmod 0555 /home/user/gdbproc.py; \
        chmod 0444 /home/user/index.html; \
        chmod 0444 /home/user/flag

RUN pip install --no-cache-dir -r /home/user/requirements.txt

USER user
CMD cd /home/user && gunicorn -c gunicorn.conf.py -b :$PORT gaas:app
