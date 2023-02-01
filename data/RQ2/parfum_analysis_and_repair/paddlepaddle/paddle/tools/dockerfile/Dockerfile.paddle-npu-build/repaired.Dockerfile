FROM registry.baidubce.com/paddlepaddle/paddle-npu:latest-dev-cann5.0.2.alpha005-gcc82-x86_64-with-driver
RUN apt-get install --no-install-recommends pigz -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove -y openjdk*
CMD ["/bin/bash"]
EXPOSE 22
