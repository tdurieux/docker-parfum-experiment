# https://github.com/tornadoweb/tornado/blob/master/demos/blog/Dockerfile
FROM python:3.6

# Port the model runtime service will listen on.
EXPOSE 8880

# Make structure where the models will live.
RUN mkdir -p /cognitiveModels/bert
RUN mkdir -p /cognitiveModels/bidaf

# Copy and install models.
COPY model /model/
#RUN pip3 install --upgrade pip
#RUN pip3 install --upgrade nltk
RUN wget https://files.pythonhosted.org/packages/69/60/f685fb2cfb3088736bafbc9bdbb455327bdc8906b606da9c9a81bae1c81e/torch-1.1.0-cp36-cp36m-manylinux1_x86_64.whl
RUN pip3 install --no-cache-dir torch-1.1.0-cp36-cp36m-manylinux1_x86_64.whl
RUN pip3 install --no-cache-dir -e /model

# Copy and install model runtime service api.
COPY model_runtime_svc /model_runtime_svc/
RUN pip3 install --no-cache-dir -e /model_runtime_svc

# One time initialization of the models.
RUN python3 /model_runtime_svc/model_runtime_svc_corebot101/docker_init.py
RUN rm /model_runtime_svc/model_runtime_svc_corebot101/docker_init.py

WORKDIR /model_runtime_svc

ENTRYPOINT ["python3", "./model_runtime_svc_corebot101/main.py"]