#Import Python Base Image(change version as needed)
FROM python:3-slim

#Install the python SDK
RUN pip install --no-cache-dir --upgrade ibm-watson >=3.2.0
