FROM ubuntu:18.04

RUN apt-get update || true
RUN apt-get install --no-install-recommends -y openjdk-11-jdk-headless && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir jupyter
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales \
    && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/frankfliu/IJava.git
RUN cd IJava/ && ./gradlew installKernel && cd .. && rm -rf IJava/
RUN rm -rf ~/.gradle

WORKDIR /home/jupyter

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

EXPOSE 8888
ENTRYPOINT ["jupyter", "notebook", "--ip=0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''",  "--NotebookApp.password=''"]
