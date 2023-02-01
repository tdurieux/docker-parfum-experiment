FROM grond-nest

# docs requirements
RUN apt-get install --no-install-recommends -y python3-sphinx \
    texlive-fonts-recommended texlive-latex-extra \
    texlive-latex-recommended texlive-generic-extra \
    python3-sphinxcontrib.programoutput && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir git+https://git.pyrocko.org/pyrocko/sphinx-sleekcat-theme.git
