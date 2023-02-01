# Start from python image
FROM python:2.7.16

# Install python dev and latex libraries
RUN apt update
RUN apt install --no-install-recommends -y texlive-fonts-recommended texlive-fonts-extra dvipng && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python-dev python-tk && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y libmpfr-dev libmpc-dev libppl-dev coinor-libipopt-dev && rm -rf /var/lib/apt/lists/*;

# Set display environment variable
ENV QT_X11_NO_MITSHM=1

# Set up home directory in image (this is where the repo directory will be mounted)
RUN mkdir /home/LMPC
WORKDIR /home/LMPC

RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir cython cysignals gmpy2==2.1.0b3
RUN pip install --no-cache-dir numpy scipy matplotlib jupyterlab
RUN pip install --no-cache-dir cvxpy pplpy
RUN apt install --no-install-recommends -y libblas-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir ipopt
RUN pip install --no-cache-dir casadi
RUN pip install --no-cache-dir scikit-learn

RUN apt install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir pypoman

# Two options for command to run

# Start jupyter notebook server
CMD jupyter lab --ip=0.0.0.0 --port=8888 --allow-root

# Keep container open after creation
# CMD tail -f /dev/null
