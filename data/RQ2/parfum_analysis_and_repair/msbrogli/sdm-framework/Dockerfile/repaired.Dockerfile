FROM ubuntu:16.04

RUN useradd -ms /bin/bash ubuntu

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y libbsd0 libbsd-dev opencl-headers python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ocl-icd-opencl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nvidia-opencl-icd-304 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy scipy matplotlib ipython jupyter pandas sympy nose pillow
RUN pip install --no-cache-dir git+https://github.com/msbrogli/sdm-framework.git

COPY docs/notebooks/*.ipynb /home/ubuntu/examples/

EXPOSE 8888

USER ubuntu
WORKDIR /home/ubuntu
CMD ["jupyter", "notebook", "--ip=0.0.0.0"]
