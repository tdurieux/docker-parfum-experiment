###################################################################################################
# DISTRIBUTION STATEMENT A. Approved for public release. Distribution is unlimited.
#
# This material is based upon work supported by the Under Secretary of Defense for Research and
# Engineering under Air Force Contract No. FA8702-15-D-0001. Any opinions, findings, conclusions
# or recommendations expressed in this material are those of the author(s) and do not necessarily
# reflect the views of the Under Secretary of Defense for Research and Engineering.
#
# (c) 2020 Massachusetts Institute of Technology.
#
# MIT Proprietary, Subject to FAR52.227-11 Patent Rights - Ownership by the contractor (May 2014)
#
# The software/firmware is provided to you on an As-Is basis
#
# Delivered to the U.S. Government with Unlimited Rights, as defined in DFARS Part 252.227-7013
# or 7014 (Feb 2014). Notwithstanding any copyright notice, U.S. Government rights in this work
# are defined by DFARS 252.227-7013 or DFARS 252.227-7014 as detailed above. Use of this work other
# than as specifically authorized by the U.S. Government may violate any copyrights that exist in
# this work.
###################################################################################################

from goseek-base:latest

RUN apt-get update && \
    apt-get install --no-install-recommends python-opencv -y && \
    pip install --no-cache-dir stable-baselines && \
    conda install tensorflow-gpu==1.13.1 && rm -rf /var/lib/apt/lists/*;

WORKDIR /goseek-challenge

COPY baselines/agents.py baselines/agents.py

COPY baselines/config/ppo-agent.yaml agent.yaml

COPY ppo-weights.pkl ppo-weights.pkl
