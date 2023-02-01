FROM unifyai/ivy:latest

# Install Ivy
RUN rm -rf ivy && \
    git clone --recurse-submodules https://github.com/unifyai/ivy && \
    cd ivy && \
    cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    cat optional.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    python3 setup.py develop --no-deps

# Install Ivy Gym
RUN git clone https://github.com/unifyai/gym && \
    cd gym && \
    cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin && \
    python3 setup.py develop --no-deps

COPY requirements.txt /
RUN cat requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin

COPY ivy_gym_demos/requirements.txt /demo_requirements.txt
RUN cat demo_requirements.txt | grep -v "ivy-" | pip3 install --no-cache-dir -r /dev/stdin

# RUN python3 test_dependencies.py -fp requirements.txt,demo_requirements.txt && \
#    rm -rf requirements.txt && \
#    rm -rf demo_requirements.txt

WORKDIR /gym
