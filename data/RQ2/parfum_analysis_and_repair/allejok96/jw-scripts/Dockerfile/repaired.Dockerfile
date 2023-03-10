FROM python:3

COPY jwlib /jwlib
COPY jwb-index /jwb-index
COPY jwb-offline /jwb-offline

ADD setup.py /

RUN pip install --no-cache-dir setuptools
RUN [ "python", "setup.py", "install" ]

ENTRYPOINT ["/bin/bash"]
