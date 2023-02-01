FROM ubuntu:18.04
# Install Python 3.8 and pip
RUN apt update && \
    apt install --no-install-recommends -y software-properties-common && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.8 && \
    apt-get install --no-install-recommends -y python3.8-dev && \
    apt-get install --no-install-recommends -y python3-pip; rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f https://bootstrap.pypa.io/ez_setup.py -o - | python3.8 && python3.8 -m easy_install pip

# Set the locale
RUN apt-get clean && apt-get -y update && apt-get install --no-install-recommends -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Project Dependencies
COPY . .
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir Cython==0.29.21
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python3.8","utils/download.py"]
CMD ["python3.8","app.py"]
EXPOSE 3355
