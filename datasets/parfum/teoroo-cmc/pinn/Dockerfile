FROM tensorflow/tensorflow:2.5.0-jupyter

# Install PiNN
RUN apt-get update && apt-get install locales seccomp -y && locale-gen en_US.UTF-8 && apt-get clean
COPY . /opt/src/pinn
RUN pip install --upgrade pip && pip install /opt/src/pinn[dev,doc,extra]
RUN jupyter nbextension enable widgetsnbextension --py --sys-prefix && \
    jupyter nbextension enable nglview --py --sys-prefix

# Setup
ENTRYPOINT ["pinn"]
