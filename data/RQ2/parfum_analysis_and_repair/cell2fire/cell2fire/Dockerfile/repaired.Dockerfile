# to build: docker build -t c2fcondatest:latest .
# local test: docker run -it --mount source=$(pwd),destination=/cell2fire,type=bind c2fcondatest:latest
# docker tag c2fcondatest dlwoodruff/c2fcondatest:latest
# docker push dlwoodruff/c2fcondatest:latest
FROM continuumio/anaconda3
RUN conda update conda
RUN conda install -c anaconda numpy
RUN pip install --no-cache-dir imread
#RUN conda install -c conda-forge imread
RUN conda install -c anaconda pandas
RUN conda install -c anaconda matplotlib
RUN conda install -c anaconda seaborn
RUN conda install -c conda-forge tqdm
RUN conda install -c conda-forge deap
#RUN conda install -c conda-forge opencv
RUN pip install --no-cache-dir opencv-python
RUN apt update
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
# we will assume that eign3 goes to /usr/include
RUN apt-get install --no-install-recommends -y libeigen3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libboost-dev && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libboost-all-dev && rm -rf /var/lib/apt/lists/*;
RUN conda install -c anaconda flake8
RUN conda install -c anaconda pytest
RUN conda install -c anaconda pytest-cov
RUN apt install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
