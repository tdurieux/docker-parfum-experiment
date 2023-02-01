FROM ubuntu:latest

RUN apt-get update

RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y libstdc++6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y gcc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3 python3-pip python3-dev python3-numpy && rm -rf /var/lib/apt/lists/*;
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh
RUN apt-get install --no-install-recommends -y python-software-properties && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y scala && rm -rf /var/lib/apt/lists/*;

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb http://download.mono-project.com/repo/debian wheezy main" | sudo tee /etc/apt/sources.list.d/mono-xamarin.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y mono-devel && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ruby && rm -rf /var/lib/apt/lists/*;
RUN gem install bundler

RUN apt-get install --no-install-recommends -y golang && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y php && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y ocaml && rm -rf /var/lib/apt/lists/*;

RUN sh -c 'echo "$(curl -fsSL https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein)" > /usr/bin/lein'
RUN chmod a+x /usr/bin/lein
RUN lein

RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir numpy scipy scikit-learn pillow h5py
RUN pip3 install --no-cache-dir --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.12.0rc0-cp35-cp35m-linux_x86_64.whl
RUN pip3 install --no-cache-dir keras

RUN apt-get install --no-install-recommends -y julia && rm -rf /var/lib/apt/lists/*;
