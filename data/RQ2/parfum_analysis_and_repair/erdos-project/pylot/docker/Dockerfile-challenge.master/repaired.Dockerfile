FROM nvidia/cudagl:11.4.2-devel-ubuntu20.04

ARG HTTP_PROXY
ARG HTTPS_PROXY
ARG http_proxy

RUN apt-get update && apt-get install --no-install-recommends --reinstall -y locales && locale-gen en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US
ENV LC_ALL en_US.UTF-8

# Install tzdata without prompt.
RUN apt-get -y update
ENV DEBIAN_FRONTEND=noninteractive
RUN DEBIAN_FRONTEND=noninteractive ; apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install -y --no-install-recommends \
         build-essential \
         cmake \
         git \
         curl \
         vim \
         ca-certificates \
         libjpeg-dev \
         libpng16-16 \
         libtiff5 \
         libpng-dev \
         python-dev \
         python3 \
         python3-dev \
         python-networkx \
         python-setuptools \
         python3-setuptools \
         python-pip \
         python3-pip && \
         pip install --no-cache-dir --upgrade pip && \
         pip3 install --no-cache-dir --upgrade pip && \
         rm -rf /var/lib/apt/lists/*

# installing conda
RUN curl -f -o ~/miniconda.sh -LO https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
     chmod +x ~/miniconda.sh && \
     ~/miniconda.sh -b -p /opt/conda && \
     rm ~/miniconda.sh && \
     /opt/conda/bin/conda clean -ya && \
     /opt/conda/bin/conda create -n python37 python=3.7 numpy networkx scipy six requests

RUN packages='py_trees==0.8.3 shapely six dictor requests ephem tabulate' \
	&& pip3 install --no-cache-dir ${packages}

WORKDIR /workspace
COPY .tmp/PythonAPI /workspace/CARLA/PythonAPI
ENV CARLA_ROOT /workspace/CARLA

ENV PATH "/workspace/CARLA/PythonAPI/carla/dist/carla-leaderboard-py3x.egg":/opt/conda/envs/python37/bin:/opt/conda/envs/bin:$PATH

# adding CARLA egg to default python environment
RUN pip install --no-cache-dir --user setuptools py_trees==0.8.3 psutil shapely six dictor requests ephem tabulate

ENV SCENARIO_RUNNER_ROOT "/workspace/scenario_runner"
ENV LEADERBOARD_ROOT "/workspace/leaderboard"
ENV TEAM_CODE_ROOT "/workspace/team_code"
ENV PYTHONPATH "/workspace/CARLA/PythonAPI/carla/dist/carla-leaderboard-py3x.egg":"${SCENARIO_RUNNER_ROOT}":"${CARLA_ROOT}/PythonAPI/carla":"${LEADERBOARD_ROOT}":${PYTHONPATH}

COPY .tmp/scenario_runner ${SCENARIO_RUNNER_ROOT}
COPY .tmp/leaderboard ${LEADERBOARD_ROOT}
COPY .tmp/team_code ${TEAM_CODE_ROOT}

RUN mkdir -p /workspace/results
RUN chmod +x /workspace/leaderboard/scripts/run_evaluation.sh


########################################################################################################################
########################################################################################################################
############                                BEGINNING OF USER COMMANDS                                      ############
########################################################################################################################
########################################################################################################################

RUN apt-get update && apt-get install --no-install-recommends -y clang libgeos-dev python-opencv libqt5core5a libeigen3-dev cmake qtbase5-dev python3-tk libcudnn8 cuda-toolkit-11-4 ssh python3-pygame && rm -rf /var/lib/apt/lists/*;
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin/:${PATH}"
RUN rustup default nightly
RUN packages='wheel setuptools setuptools-rust fire' && pip install --no-cache-dir ${packages}
RUN git clone https://github.com/erdos-project/erdos.git && cd erdos && python3 python/setup.py install --user

RUN packages='absl-py cvxpy gdown lapsolver matplotlib==3.4.3 motmetrics numpy==1.19.5 open3d==0.13.0 opencv-python>=4.1.0.25 opencv-contrib-python>=4.1.0.25 pillow>=6.2.2 pytest scikit-image==0.18.3 scipy==1.7.1 shapely==1.6.4 tensorflow-gpu==2.5.1 torch==1.4.0 torchvision==0.5.0 filterpy==1.4.1 scikit-learn==1.0 imgaug==0.2.8 nonechucks==0.3.1 Cython progress pyquaternion nuscenes-devkit' \
	&& pip install --no-cache-dir ${packages}
ENV PYTHONPATH ${TEAM_CODE_ROOT}/:${TEAM_CODE_ROOT}/dependencies/:${PYTHONPATH}
ENV TEAM_AGENT ${TEAM_CODE_ROOT}/pylot/simulation/challenge/ERDOSAgent.py
ENV TEAM_CONFIG ${TEAM_CODE_ROOT}/pylot/simulation/challenge/challenge.conf
ENV CHALLENGE_TRACK_CODENAME MAP
ENV PYLOT_HOME ${TEAM_CODE_ROOT}/

RUN cd ${TEAM_CODE_ROOT}/dependencies/frenet_optimal_trajectory_planner && rm -r build && ./build.sh
RUN cd ${TEAM_CODE_ROOT}/dependencies/hybrid_astar_planner && rm -r build && ./build.sh
RUN cd ${TEAM_CODE_ROOT}/dependencies/rrt_star_planner && rm -r build && ./build.sh

########################################################################################################################
########################################################################################################################
############                                   END OF USER COMMANDS                                         ############
########################################################################################################################
########################################################################################################################

ENV SCENARIOS ${LEADERBOARD_ROOT}/data/all_towns_traffic_scenarios_public.json
ENV ROUTES ${LEADERBOARD_ROOT}/data/routes_training.xml
ENV REPETITIONS 1
ENV CHECKPOINT_ENDPOINT /workspace/results/results.json
ENV DEBUG_CHALLENGE 0

ENV HTTP_PROXY ""
ENV HTTPS_PROXY ""
ENV http_proxy ""
ENV https_proxy ""


CMD ["/bin/bash"]
