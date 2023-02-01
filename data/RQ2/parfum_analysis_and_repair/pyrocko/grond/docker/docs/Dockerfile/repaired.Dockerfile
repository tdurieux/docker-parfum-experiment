FROM grond-nest

# docs requirements
RUN apt-get update && apt-get install --no-install-recommends -y \
    texlive-fonts-recommended texlive-latex-extra \
    texlive-latex-recommendedt exlive-generic-extra && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir sphinx sphinxcontrib-programoutput git+https://git.pyrocko.org/pyrocko/sphinx-sleekcat-theme.git
