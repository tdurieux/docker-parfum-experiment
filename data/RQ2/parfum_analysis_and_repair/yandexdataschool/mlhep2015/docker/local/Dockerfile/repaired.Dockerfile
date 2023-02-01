FROM anaderi/rep-develop:latest
MAINTAINER Andrey Ustyuzhanin <anaderi@yandex-team.ru>

RUN apt-get install --no-install-recommends -y libpython3-dev python3-pip vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

#LIBS
RUN pip install --no-cache-dir git+https://github.com/arogozhnikov/hep_ml.git

# George
RUN pip install --no-cache-dir cython
RUN apt-get install --no-install-recommends -y libeigen3-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir git+https://github.com/dfm/george.git


# Bayesian Opt
RUN pip install --no-cache-dir git+https://github.com/scr4t/BayesianOptimization.git

# Update pandas
RUN pip install --no-cache-dir -U pandas

# Stuff
RUN pip install --no-cache-dir astroML
RUN pip install --no-cache-dir seaborn


RUN pip3 install --no-cache-dir ipython[all]==3.2.1

# add support for Python2 kernels
RUN ipython2 kernelspec install-self

#
ENV JOBLIB_TEMP_FOLDER /tmp
ENV TERM xterm

RUN mkdir /work
VOLUME /work

EXPOSE 8888
COPY notebook.sh /root/notebook.sh
CMD ["/root/notebook.sh"]
