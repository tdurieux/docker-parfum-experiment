FROM ubuntu:18.04
LABEL maintainer="ricardo@simbiotic.ai"

RUN apt update && apt install --no-install-recommends -y wget python3 python3-pip emacs vim && rm -rf /var/lib/apt/lists/*;
RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y esl-erlang elixir && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-opengl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y xvfb xserver-xephyr vnc4server && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pil scrot && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y lsof telnet && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential erlang-dev libatlas-base-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR /gyx
COPY . .

RUN mix local.hex --force && mix local.rebar --force
RUN mix deps.get

RUN mv /gyx/priv/.iex.exs ~/

RUN pip3 install --no-cache-dir https://download.pytorch.org/whl/cpu/torch-1.0.1.post2-cp36-cp36m-linux_x86_64.whl
#RUN pip3 install torchvision
RUN pip3 install --no-cache-dir ipython
RUN pip3 install --no-cache-dir pyvirtualdisplay
RUN pip3 install --no-cache-dir gym[atari]
#RUN pip3 install gym-retro

ENV TERM xterm
ENV LANG en_US.UTF-8 
ENV LANGUAGE en_US:en 
ENV LC_ALL en_US.UTF-8 

ENV APP_NAME gyx
ENV MIX_ENV dev


#ENTRYPOINT ["iex", "-S", "mix"]
