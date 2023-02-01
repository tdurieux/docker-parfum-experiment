FROM ansiblesemaphore/semaphore:dynamicVars
USER root
RUN apk update
RUN apk add --no-cache py3-pip
RUN pip3 install --no-cache-dir pyvmomi
