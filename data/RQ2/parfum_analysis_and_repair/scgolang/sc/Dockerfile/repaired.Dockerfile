FROM            ubuntu:14.04
RUN 		sudo add-apt-repository ppa:supercollider/ppa
RUN		sudo apt-get update
RUN sudo apt-get install -y --no-install-recommends supercollider && rm -rf /var/lib/apt/lists/*;
