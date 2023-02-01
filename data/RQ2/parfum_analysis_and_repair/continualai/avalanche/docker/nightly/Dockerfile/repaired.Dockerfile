FROM continualai/avalanche-test-3.9:latest

WORKDIR ~

RUN echo "conda activate avalanche-env" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

RUN pip install --no-cache-dir git+https://github.com/ContinualAI/avalanche.git
