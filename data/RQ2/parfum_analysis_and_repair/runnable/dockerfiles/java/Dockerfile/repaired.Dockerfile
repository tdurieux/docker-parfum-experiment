# runnable base
FROM boxcar/raring

# REPOS
RUN apt-get -y update && date
RUN apt-get install --no-install-recommends -y -q software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get -y update

#SHIMS
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl
ENV DEBIAN_FRONTEND noninteractive

# EDITORS
RUN apt-get install --no-install-recommends -y -q vim nano && rm -rf /var/lib/apt/lists/*;

# TOOLS
RUN apt-get install --no-install-recommends -y -q curl git make wget && rm -rf /var/lib/apt/lists/*;

# BUILD
RUN apt-get install --no-install-recommends -y -q build-essential g++ && rm -rf /var/lib/apt/lists/*;

# LANGS
RUN apt-get install --no-install-recommends -y -q openjdk-7-jre-headless && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y -q openjdk-7-jdk && rm -rf /var/lib/apt/lists/*;

## NODE
RUN apt-get install --no-install-recommends -y -q nodejs && rm -rf /var/lib/apt/lists/*;

