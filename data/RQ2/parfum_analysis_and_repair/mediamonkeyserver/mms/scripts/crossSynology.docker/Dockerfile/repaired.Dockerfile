FROM ubuntu

# ==== Basic setup ====
RUN apt-get -qq update && apt-get -qq --no-install-recommends -y install curl build-essential python git python3 xz-utils wget && rm -rf /var/lib/apt/lists/*;

# ==== Synology setup =====
RUN mkdir -p /synotoolkit
WORKDIR "/synotoolkit"
RUN git clone https://github.com/SynologyOpenSource/pkgscripts-ng pkgscripts
WORKDIR "/synotoolkit/pkgscripts"

# Workaround for tar problems with Docker (use bsdtar instead)
#RUN sed -i "s/'tar'/'bsdtar'/g" EnvDeploy               # tar problem in Docker
#RUN sed -i "s/'-xhf'/'-xf'/g" EnvDeploy                 # tar problem in Docker
# End of workaround

# For a particular Synology NAS model (armv7 instructions). We'll probably need more builds...
# armada370 has an old gcc, doesn't work well for me
# RUN ./EnvDeploy -v 6.0 -p armada370
#RUN ./EnvDeploy -v 6.2 -p armada38x
RUN ./EnvDeploy -v 6.2 -p rtd1296
# alpine4k is quite recent armv7 platform, seems to be usable e.g. for armada370 as well
# Doesn't compile node.js though, can be removed?
#RUN ./EnvDeploy -v 6.2 -p alpine4k
# evansport (x86)
#RUN ./EnvDeploy -v 6.2 -p evansport
#RUN ./EnvDeploy -v 6.2 -p alpine