# TensorFlow & scikit-learn with Python3.7
FROM python:3.7
LABEL maintainer “Shiho ASA<asashiho@mail.asa.yokohama>”

# Install dependencies
RUN apt-get update && apt-get install -y \
    libblas-dev \
	liblapack-dev\
    libatlas-base-dev \
    mecab \
    mecab-naist-jdic \
    mecab-ipadic-utf8 \
    swig \
    libmecab-dev \
	gfortran \
    libav-tools \
    python3-setuptools

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install TensorFlow CPU version
ENV TENSORFLOW_VERSION 1.13.1
RUN pip --no-cache-dir install \
    http://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-${TENSORFLOW_VERSION}-cp37-cp37m-linux_x86_64.whl


# Install Python library for Data Science
RUN pip --no-cache-dir install \
        keras \
        sklearn \
        jupyter \
        ipykernel \
		scipy \
        simpy \
        matplotlib \
        numpy \
        pandas \
        plotly \
        sympy \
        mecab-python3 \
        librosa \
        Pillow \
        h5py \
        google-api-python-client \
        tornado==5.1.1 \
        && \
    python -m ipykernel.kernelspec

# Set up Jupyter Notebook config
ENV CONFIG /root/.jupyter/jupyter_notebook_config.py
ENV CONFIG_IPYTHON /root/.ipython/profile_default/ipython_config.py 

RUN jupyter notebook --generate-config --allow-root && \
    ipython profile create

RUN echo "c.NotebookApp.ip = '0.0.0.0'" >>${CONFIG} && \
    echo "c.NotebookApp.port = 8888" >>${CONFIG} && \
    echo "c.NotebookApp.open_browser = False" >>${CONFIG} && \
    echo "c.NotebookApp.iopub_data_rate_limit=10000000000" >>${CONFIG} && \
    echo "c.MultiKernelManager.default_kernel_name = 'python3'" >>${CONFIG} 

RUN echo "c.InteractiveShellApp.exec_lines = ['%matplotlib inline']" >>${CONFIG_IPYTHON} 

# Copy sample notebooks.
COPY notebooks /notebooks

# Port
EXPOSE 8888
EXPOSE 6006 

VOLUME /notebooks

# Run Jupyter Notebook
WORKDIR "/notebooks"
CMD ["jupyter","notebook", "--allow-root"]
