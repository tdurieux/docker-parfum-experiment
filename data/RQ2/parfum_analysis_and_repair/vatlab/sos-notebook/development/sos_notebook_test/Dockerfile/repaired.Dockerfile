# Copyright (c) Bo Peng and the University of Texas MD Anderson Cancer Center
# Distributed under the terms of the 3-clause BSD License.

# tag created in March 2019

FROM jupyter/r-notebook:83ed2c63671f

MAINTAINER Bo Peng <Bo.Peng@bcm.edu>

USER    root


#       Tools
RUN apt-get update && apt-get install --no-install-recommends -y graphviz texlive-xetex texlive-latex-recommended texlive-latex-extra texlive-fonts-recommended libssl1.0.0 libssl-dev libappindicator3-1 libxtst6 libgmp3-dev software-properties-common rsync ssh && rm -rf /var/lib/apt/lists/*;

USER    jovyan

RUN pip install --no-cache-dir bash_kernel selenium nose
RUN     python -m bash_kernel.install --user

RUN pip install --no-cache-dir markdown wand graphviz imageio pillow nbformat coverage codacy-coverage pytest pytest-cov python-coveralls
RUN     conda install -y feather-format -c conda-forge
RUN 	conda install -c r r-arrow r-dplyr

## trigger rerun for sos updates
RUN	    DUMMY=$(git ls-remote https://github.com/vatlab/sos.git -t master)
RUN DUMMY=${DUMMY} pip --no-cache-dir install git+https://github.com/vatlab/sos.git
RUN pip install --no-cache-dir sos-r sos-python sos-bash --upgrade
RUN pip install --no-cache-dir ipython -U

USER    root
RUN curl -f https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

RUN wget -q "https://chromedriver.storage.googleapis.com/76.0.3809.126/chromedriver_linux64.zip" -O /tmp/chromedriver.zip \
    && unzip /tmp/chromedriver.zip -d /usr/bin/ \
    && rm /tmp/chromedriver.zip
ENV DISPLAY=:99

RUN ln -s /usr/bin/chromedriver && chmod 777 /usr/bin/chromedriver
RUN chmod 777 /home/jovyan/.local/share/jupyter/


COPY ./.ssh /root/.ssh
RUN chmod 700 /root/.ssh
RUN chmod 600 /root/.ssh/*

COPY ./.ssh /home/jovyan/.ssh
RUN chmod 700 /home/jovyan/.ssh
RUN chmod 600 /home/jovyan/.ssh/*

USER    jovyan
