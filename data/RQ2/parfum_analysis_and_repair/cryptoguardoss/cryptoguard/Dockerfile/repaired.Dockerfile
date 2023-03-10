FROM openjdk:11.0.7-jdk

RUN apt-get update
RUN apt update

RUN yes | apt-get install -y --no-install-recommends zip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

# Downloading the Android Library
RUN cd /opt && \
	wget --output-document=android-sdk.zip --quiet https://dl.google.com/android/repository/android-22_r02.zip && \
	unzip android-sdk.zip && \
	rm -f android-sdk.zip && \
	mv android-5.1.1 android && \
	chown -R 777 android

# add requirements.txt, written this way to gracefully ignore a missing file
COPY . .
RUN ([ -f requirements.txt ] \
    && pip3 install --no-cache-dir -r requirements.txt) \
        || pip3 install --no-cache-dir jupyter jupyterlab

USER root

# Download the kernel release
RUN curl -f -L https://github.com/SpencerPark/IJava/releases/download/v1.3.0/ijava-1.3.0.zip > ijava-kernel.zip

# Unpack and install the kernel
RUN unzip ijava-kernel.zip -d ijava-kernel \
  && cd ijava-kernel \
  && python3 install.py --sys-prefix

# Set up the user environment
ENV NB_USER runner
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Installing SDK Man
RUN curl -f -s "https://get.sdkman.io" | bash

# Installing Java and Maven, removing some unnecessary SDKMAN files
RUN bash -c "source /home/runner/.sdkman/bin/sdkman-init.sh &&  yes | sdk install java $(sdk ls java|grep 11.0.*-hs-adpt|head -n 1|cut -d '|' -f6|awk '{$1=$1};1')"
RUN bash -c "source /home/runner/.sdkman/bin/sdkman-init.sh &&  yes | sdk install java $(sdk ls java|grep 7.0.*-zulu|head -n 1|cut -d '|' -f6|awk '{$1=$1};1')"
RUN bash -c "source /home/runner/.sdkman/bin/sdkman-init.sh &&  yes | sdk install java $(sdk ls java|grep 8.0.*-zulu|head -n 1|cut -d '|' -f6|awk '{$1=$1};1')"
RUN bash -c "source /home/runner/.sdkman/bin/sdkman-init.sh &&  yes | sdk install gradle 6.0"

USER root

RUN mkdir -p /home/runner/.sdkman/candidates/android/22_r02
RUN mv /opt/android /home/runner/.sdkman/candidates/android/22_r02/platforms
RUN ln -s /home/runner/.sdkman/candidates/android/22_r02/platforms /home/runner/.sdkman/candidates/android/current

RUN chmod 777 -R /home/runner/.sdkman

USER $NB_USER

RUN bash -c "echo \"jupyter lab --ip=0.0.0.0\">>/home/runner/.bash_aliases"

# Launch the notebook server
WORKDIR $HOME
CMD ["jupyter", "lab", "--ip", "0.0.0.0"]
