# Dockerfile for the 2014 SciPy Conference tutorial
#
#  Reproducible Research: Walking the Walk
#
# Make sure to use a persistent Docker image tag
FROM       phusion/baseimage:0.9.10
MAINTAINER Ana Nelson <ana@ananelson.com>

# Set the locale to UTF-8
RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 || true

# Use squid deb proxy (if available on host OS)
# as per https://gist.github.com/dergachev/8441335
ENV HOST_IP_FILE /tmp/host-ip.txt
RUN /sbin/ip route | awk '/default/ { print "http://"$3":8000" }' > $HOST_IP_FILE
RUN HOST_IP=`cat $HOST_IP_FILE` && curl -f -s $HOST_IP | grep squid && echo "found squid" && echo "Acquire::http::Proxy \"$HOST_IP\";" > /etc/apt/apt.conf.d/30proxy || echo "no squid"

### "update"
RUN apt-get update

### "utils"
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y adduser && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y sudo && rm -rf /var/lib/apt/lists/*;

### "nice-things"
RUN apt-get install --no-install-recommends -y ack-grep && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y vim && rm -rf /var/lib/apt/lists/*;

### "git"
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

### "python"
RUN apt-get install --no-install-recommends -y python-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;

### "scipy"
RUN apt-get install --no-install-recommends -y python-numpy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ipython && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y ipython-notebook && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-nose && rm -rf /var/lib/apt/lists/*;

### "dexy"
RUN pip install --no-cache-dir dexy

### "latex"
RUN apt-get install --no-install-recommends -y pandoc && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends texlive-latex-base && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends texlive-latex-extra && rm -rf /var/lib/apt/lists/*;

### "itk"
RUN easy_install SimpleITK

### "mplayer"
RUN apt-get install --no-install-recommends -y mplayer && rm -rf /var/lib/apt/lists/*;

### "create-user"
RUN useradd -m -p $(perl -e'print crypt("foobarbaz", "aa")') repro
RUN adduser repro sudo
RUN chown -R repro.repro /home/repro

### "activate-user"
ENV HOME /home/repro
USER repro
WORKDIR /home/repro
