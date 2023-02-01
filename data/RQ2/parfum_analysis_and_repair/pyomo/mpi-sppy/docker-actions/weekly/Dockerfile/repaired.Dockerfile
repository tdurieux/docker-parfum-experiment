# docker build . -t mpisppyweekly:latest
# to test locally:
# docker run -it mpisppyweekly:latest
# docker run -v /home/woodruff/Documents/Research/mpi-sppy/:/mpi-sppy -it mpisppyweekly:latest
# (see also the cell2fire Dockerfile)
# docker tag c2fcondatest dlwoodruff/mpisppyweekly:latest
# docker push dlwoodruff/mpisppyweekly:latest
##############################################
FROM continuumio/anaconda3
RUN conda update conda
RUN conda install -c anaconda numpy
RUN conda install -c anaconda pandas

RUN apt-get update && apt-get install --no-install-recommends -y mpich && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir mpi4py
RUN pip install --no-cache-dir xpress

RUN apt update
RUN apt install --no-install-recommends -y git-all && rm -rf /var/lib/apt/lists/*;

# get pyomo from the web

RUN git clone https://github.com/pyomo/pyomo

RUN cd pyomo && python setup.py develop
