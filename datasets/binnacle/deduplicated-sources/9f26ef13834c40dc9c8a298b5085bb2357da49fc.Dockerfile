# docker build -t markdown2tufte .
# docker run -it -v `pwd`:/data markdown2tufte /bin/bash -c "cd /data && markdown2tufte && useradd $USER && chown -R $USER:$USER public/"
FROM phusion/baseimage:0.9.22

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# ...put your own build instructions here...
RUN apt-get update
RUN apt-get install -y git wget imagemagick

# Install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/1.18/pandoc-1.18-1-amd64.deb
RUN dpkg --install pandoc-1.18-1-amd64.deb

# Install pandoc-sitenote
RUN wget https://github.com/schollz/pandoc-sidenote/releases/download/v1.0/pandoc-sidenote
RUN chmod +x pandoc-sidenote
RUN mv pandoc-sidenote /usr/local/bin

# Install book
RUN apt-get install -y python3 python3-pip
RUN python3 -m pip install toml
RUN git clone https://github.com/schollz/markdown2tufte.git
WORKDIR markdown2tufte
RUN python3 setup.py install

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


