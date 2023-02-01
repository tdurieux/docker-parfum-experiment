# Latex-Online container
#
# VERSION       1

# use the ubuntu base image provided by dotCloud
FROM node:8.9.1-stretch

MAINTAINER Andrey Lushnikov aslushnikov@gmail.com

# Sorted list of used packages.
RUN apt-get clean && apt-get update && apt-get install -y \
    biber \
    cm-super \
    fontconfig \
    git-core \
    latex-xcolor \
    preview-latex-style \
    python3 \
    texlive-bibtex-extra \
    texlive-fonts-extra \
    texlive-generic-extra \
    texlive-lang-all \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-math-extra \
    texlive-publishers \
    texlive-science \
    texlive-xetex

# Add xindy-2.2 instead of makeindex.
ADD ./packages/xindy-2.2-rc2-linux.tar.gz /opt
ENV PATH="/opt/xindy-2.2/bin:${PATH}"

COPY ./util/docker-entrypoint.sh /

EXPOSE 2700
CMD ["./docker-entrypoint.sh"]

