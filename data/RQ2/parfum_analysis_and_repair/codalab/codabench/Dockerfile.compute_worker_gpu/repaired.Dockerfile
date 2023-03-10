FROM python:3.8.1-buster

# We need curl to get docker/nvidia-docker
RUN apt-get update && apt-get install --no-install-recommends curl wget -y && rm -rf /var/lib/apt/lists/*;

# This makes output not buffer and return immediately, nice for seeing results in stdout
ENV PYTHONUNBUFFERED 1

# Install a specific version of docker
RUN curl -f -sSL https://get.docker.com/ | sed 's/docker-ce/docker-ce=18.03.0~ce-0~debian/' | sh

# nvidia-docker jazz
RUN curl -f -s -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
RUN curl -f -s -L https://nvidia.github.io/nvidia-docker/$(. /etc/os-release;echo $ID$VERSION_ID)/nvidia-docker.list | \
  tee /etc/apt/sources.list.d/nvidia-docker.list
RUN apt-get update && apt-get install --no-install-recommends -y nvidia-docker2 && rm -rf /var/lib/apt/lists/*;

# make it explicit that we're using GPUs
ENV NVIDIA_DOCKER 1

# Python reqs and actual worker stuff
ADD docker/compute_worker/compute_worker_requirements.txt .
RUN pip3 install --no-cache-dir -r compute_worker_requirements.txt
ADD docker/compute_worker .

CMD celery -A compute_worker worker \
    -l info \
    -Q compute-worker \
    -n compute-worker@%n \
    --concurrency=1
