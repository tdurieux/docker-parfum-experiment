ARG BASE_IMAGE=pytorch/pytorch:1.10.0-cuda11.3-cudnn8-runtime
FROM $BASE_IMAGE

# install utilities and dependencies
RUN pip install --no-cache-dir classy-vision

WORKDIR /workspace

# download imagenet tiny for data
RUN apt-get -q update && apt-get -q --no-install-recommends install -y wget unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -q https://cs231n.stanford.edu/tiny-imagenet-200.zip && unzip -q tiny-imagenet-200.zip -d data && rm tiny-imagenet-200.zip

COPY . ./examples
RUN chmod -R u+x ./examples/bin
ENV PATH=/workspace/examples/bin:${PATH}

# create a template classy project in /workspace/classy_vision
# (see https://classyvision.ai/#quickstart)
RUN classy-project classy_vision

USER root
ENTRYPOINT ["python", "-m", "torch.distributed.run"]
CMD ["--help"]
