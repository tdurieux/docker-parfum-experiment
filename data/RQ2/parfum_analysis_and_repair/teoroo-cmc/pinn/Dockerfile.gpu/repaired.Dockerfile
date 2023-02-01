FROM tensorflow/tensorflow:2.5.0-gpu-jupyter

# Install PiNN
RUN apt-get update && apt-get install --no-install-recommends locales seccomp -y && locale-gen en_US.UTF-8 && apt-get clean && rm -rf /var/lib/apt/lists/*;
COPY . /opt/src/pinn
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir /opt/src/pinn[dev,doc,extra]
RUN jupyter nbextension enable widgetsnbextension --py --sys-prefix && \
    jupyter nbextension enable nglview --py --sys-prefix

# Setup
ENTRYPOINT ["pinn"]
