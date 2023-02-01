FROM registry.baidubce.com/qili93/paddle-mlu:neuware-latest
RUN apt-get install --no-install-recommends pigz -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get remove -y openjdk*
CMD ["/bin/bash"]
EXPOSE 22
