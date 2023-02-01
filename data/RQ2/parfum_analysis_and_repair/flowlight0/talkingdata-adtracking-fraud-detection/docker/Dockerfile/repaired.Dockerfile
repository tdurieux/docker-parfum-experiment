FROM kaggle/python

WORKDIR /root/
RUN git clone https://github.com/flowlight0/talkingdata-adtracking-fraud-detection.git

WORKDIR /root/talkingdata-adtracking-fraud-detection
RUN apt-get install --no-install-recommends awscli -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir --upgrade awscli
RUN pip install --no-cache-dir kaggle
RUN conda install arrow-cpp=0.9.* -c conda-forge
RUN conda install numba
