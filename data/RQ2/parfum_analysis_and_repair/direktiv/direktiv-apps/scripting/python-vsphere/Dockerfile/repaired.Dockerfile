FROM direktiv/python:v2

RUN pip install --no-cache-dir --upgrade pip setuptools
RUN pip install --no-cache-dir --upgrade git+https://github.com/vmware/vsphere-automation-sdk-python.git

