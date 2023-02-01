FROM pytorch/pytorch:latest

RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir gym
