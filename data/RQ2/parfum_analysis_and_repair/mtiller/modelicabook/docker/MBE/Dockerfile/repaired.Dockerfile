FROM ubuntu:14.04

# Update index
RUN apt-get update

# Install weget
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# Add OpenModelica stable build
RUN for deb in deb deb-src; do echo "$deb http://build.openmodelica.org/apt `lsb_release -cs` stable"; done | sudo tee /etc/apt/sources.list.d/openmodelica.list
RUN wget -q https://build.openmodelica.org/apt/openmodelica.asc -O- | sudo apt-key add -

# Update index (again)
RUN apt-get update

# Install OpenModelica
RUN apt-get install --no-install-recommends -y openmodelica && rm -rf /var/lib/apt/lists/*;

RUN apt-get update

# Now Install base Python
RUN apt-get install --no-install-recommends -y python python-dev python-pip python-virtualenv && rm -rf /var/lib/apt/lists/*;

# Now a bunch of dependencies required for building the book
RUN apt-get install --no-install-recommends -y calibre && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y librsvg2-bin && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-fonts-recommended && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-latex-recommended && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-latex-extra && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-matplotlib && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-scipy && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-sphinx && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python-jinja2 && rm -rf /var/lib/apt/lists/*;

# Install Sphinx internationalization stuff
RUN pip install --no-cache-dir sphinx-intl
RUN apt-get install --no-install-recommends -y fonts-droid && rm -rf /var/lib/apt/lists/*;

# Install internationalization packages needed for the book
RUN apt-get install --no-install-recommends -y latex-cjk-common && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-xetex && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y texlive-generic-extra && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y fonts-arphic-gkai00mp fonts-arphic-ukai fonts-arphic-uming \
    fonts-arphic-bkai00mp fonts-arphic-bsmi00lp fonts-arphic-gbsn00lp && rm -rf /var/lib/apt/lists/*;

# Temporary: use the newest s3cmd
RUN pip install --no-cache-dir --upgrade s3cmd

# Now install Git and grab the book
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;

# Workaround: use an older version of sphinx-intl to workaround a bug in upstream
RUN pip install --no-cache-dir --upgrade 'sphinx-intl==0.9.6'
RUN pip install --no-cache-dir --upgrade 'sphinx==1.3'

# Because I was running into this: https://github.com/sphinx-doc/sphinx/issues/3212
RUN pip install --no-cache-dir docutils==0.12


# Create a directory for all the book related stuff
RUN mkdir /opt/MBE

# The rest of this we do as a user
RUN useradd builder

COPY default_s3cfg /home/builder/.s3cfg
RUN chown builder:builder /home/builder/.s3cfg

RUN chown builder /opt/MBE

USER builder

WORKDIR /opt/MBE

#RUN git clone https://github.com/xogeny/ModelicaBook.git
# Instead of checking this out from Git (because then we can
# only build *master*, we'll mount the repo as a volume)

# The default commands when run as a container
WORKDIR /opt/MBE/ModelicaBook/text
CMD ["/bin/bash", "build_all.sh"]
