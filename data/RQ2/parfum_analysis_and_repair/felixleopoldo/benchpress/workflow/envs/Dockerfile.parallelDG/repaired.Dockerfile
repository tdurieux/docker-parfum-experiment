FROM onceltuca/trilearn:1.23

RUN mkdir git
WORKDIR /git
RUN git clone https://github.com/melmasri/parallelDG.git
WORKDIR /git/parallelDG
RUN git fetch --all --tag # This is not triggered if the version is changed. It should be.
RUN git checkout v0.5 -b latest
RUN pip install --no-cache-dir -r requirements.txt
ENV PYTHONPATH /git:/git/parallelDG:/git/parallelDG/bin
ENV PATH /git/parallelDG/bin:$PATH
RUN chmod 755 bin/*
RUN apt install -y --no-install-recommends time && rm -rf /var/lib/apt/lists/*;
