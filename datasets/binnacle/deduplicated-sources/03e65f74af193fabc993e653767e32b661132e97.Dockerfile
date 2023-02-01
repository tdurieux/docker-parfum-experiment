# Docker file for JuliaBox
# Version:42

FROM julialang/juliaboxpkgdist:v0.3.12
# Switching the base to the bare julia image helps during JuliaBox development by reducing image size
# FROM julialang/julia:v0.3.12

MAINTAINER Tanmay Mohapatra

RUN ln -fs /opt/julia/bin/julia /usr/bin/julia
RUN git clone https://github.com/tanmaykm/shellinabox_fork.git; cd shellinabox_fork; ./configure; make install; cd ..; rm -rf shellinabox_fork

# CloudArray dependencies
RUN apt-get install -y sshpass

# add juser
# create group and user with specific ids if required on systems where the user running juliabox is not the first user
RUN groupadd juser \
    && useradd -m -d /home/juser -s /bin/bash -g juser -G staff juser \
    && echo "export HOME=/home/juser" >> /home/juser/.bashrc

# link Julia v0.3
RUN ln -fs /opt/julia_0.3.12 /opt/julia-0.3.12 && \
    ln -fs /opt/julia-0.3.12 /opt/julia-0.3

# add Julia v0.4 build
RUN mkdir -p /opt/julia-0.4.6 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.4/julia-0.4.6-linux-x86_64.tar.gz | tar -C /opt/julia-0.4.6 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.4.6 /opt/julia-0.4

# add Julia v0.5 nightly build
RUN mkdir -p /opt/julia-0.5.0-dev && \
    curl -s -L https://status.julialang.org/download/linux-x86_64 | tar -C /opt/julia-0.5.0-dev -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.5.0-dev /opt/julia-0.5

# make Julia 0.4 the default
RUN rm /opt/julia && ln -fs /opt/julia-0.4.6 /opt/julia

# JuliaBox package bundle shall be mounted at /opt/julia_packages.
# They are added to LOAD_PATH through respective juliarc.jl scripts.
RUN mkdir /opt/julia_packages
RUN echo 'push!(LOAD_PATH, "/opt/julia_packages/.julia/v0.5/"); push!(Base.LOAD_CACHE_PATH, "/opt/julia_packages/.julia/lib/v0.5"); try using JuliaBoxUtils; JuliaBoxUtils.SysLim.setrlimit(JuliaBoxUtils.SysLim.RLIMIT_NOFILE, 256) end' >> /opt/julia-0.5/etc/julia/juliarc.jl
RUN echo 'push!(LOAD_PATH, "/opt/julia_packages/.julia/v0.4/"); push!(Base.LOAD_CACHE_PATH, "/opt/julia_packages/.julia/lib/v0.4"); try using JuliaBoxUtils; JuliaBoxUtils.SysLim.setrlimit(JuliaBoxUtils.SysLim.RLIMIT_NOFILE, 256) end' >> /opt/julia-0.4/etc/julia/juliarc.jl
RUN echo 'push!(LOAD_PATH, "/opt/julia_packages/.julia/v0.3/"); try using JuliaBoxUtils; JuliaBoxUtils.SysLim.setrlimit(JuliaBoxUtils.SysLim.RLIMIT_NOFILE, 256) end' >> /opt/julia-0.3/etc/julia/juliarc.jl

# Data volumes shall be mounted at /mnt/data
RUN mkdir /mnt/data
RUN mkdir /opt/juliabox

RUN echo "ulimit -u 2048 -n 256" >> /etc/bash.bashrc

USER juser
ENV HOME /home/juser
ENV PATH /usr/local/texlive/2014/bin/x86_64-linux:/usr/local/bin:/usr/bin:/bin:/sbin:/usr/sbin:/opt/julia/bin
WORKDIR /home/juser

# 4200: http port for console
# 8000: http port for tornado
# 8998: ipython port for julia
# 8050-8052: user specified applications
EXPOSE  4200 8000 8998 8050 8051 8052

ENTRYPOINT ["/usr/bin/supervisord", "-n", "-c", "/opt/juliabox/.juliabox/supervisord.conf", "-l", "/opt/juliabox/.juliabox/supervisord.log", "-j", "/opt/juliabox/.juliabox/supervisord.pid", "-q", "/opt/juliabox/.juliabox"]
