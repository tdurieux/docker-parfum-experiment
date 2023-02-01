FROM pytorch/pytorch

#RUN mkdir /tmp/build/
#COPY . /tmp/build
#RUN find /tmp/build/

# Install OpenMPI per https://spinningup.openai.com/en/latest/user/installation.html#installing-openmpi
RUN apt-get update && apt-get install --no-install-recommends libopenmpi-dev -y && rm -rf /var/lib/apt/lists/*;

# Cache requirements
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Install ssh for openmpi
RUN apt-get install --no-install-recommends ssh -y && rm -rf /var/lib/apt/lists/*;

COPY repos/deepdrive-zero deepdrive-zero
COPY repos/spinningup spinningup

RUN cd deepdrive-zero && pip install --no-cache-dir -e .
RUN cd spinningup && pip install --no-cache-dir -e .

#https://raw.githubusercontent.com/crizCraig/dotfiles/master/.inputrc