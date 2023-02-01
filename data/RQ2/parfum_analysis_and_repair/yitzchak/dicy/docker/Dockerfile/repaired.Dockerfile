FROM ubuntu:14.04
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN sudo sh -c 'echo "deb http://cran.rstudio.com/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list'
RUN gpg --batch --keyserver keyserver.ubuntu.com --recv-key E084DAB9
RUN gpg --batch -a --export E084DAB9 | sudo apt-key add -
# RUN apt-add-repository -y ppa:aims/sagemath
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y --no-install-recommends install build-essential libssl-dev curl git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install texlive-latex-base texlive-latex-recommended texlive-latex-extra texlive-bibtex-extra texlive-metapost texlive-xetex biber feynmf latex-xcolor xindy texlive-lang-cjk && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pygments asymptote r-recommended lhs2tex && rm -rf /var/lib/apt/lists/*;
# RUN apt-get -y install sagemath-upstream-binary
# RUN cp -rv /usr/lib/sagemath/local/share/texmf/tex /usr/local/share/texmf
# RUN mktexlsr
RUN curl -f -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
RUN mkdir -p ~/R/library
RUN Rscript -e "install.packages(c('knitr', 'patchSynctex'), repos = 'http://cran.r-project.org')"
COPY dicy-test ~/dicy-test
ENTRYPOINT ["~/dicy-test"]
