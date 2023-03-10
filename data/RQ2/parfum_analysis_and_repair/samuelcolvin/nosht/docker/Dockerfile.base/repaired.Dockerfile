FROM python:3.6-alpine3.9

RUN apk add --no-cache -U gcc g++ musl-dev zlib-dev libuv libffi-dev make openssl-dev git jpeg-dev openjpeg libjpeg-turbo tiff-dev

ADD ./py/requirements.txt /home/root/requirements.txt
RUN pip install --no-cache-dir -r /home/root/requirements.txt
# get rid of unnecessary files to keep the size of site-packages and the final image down
RUN find /usr/local/lib/python3.6/site-packages \
    -name '*.pyc' -o \
    -name '*.pyx' -o \
    -name '*.pyd' -o \
    -name '*.c' -o \
    -name '*.h' -o \
    -name '*.txt' | xargs rm
RUN find /usr/local/lib/python3.6/site-packages -name '__pycache__' -delete
