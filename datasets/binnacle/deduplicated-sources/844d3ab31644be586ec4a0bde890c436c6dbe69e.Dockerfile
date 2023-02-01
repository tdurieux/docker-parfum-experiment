FROM jupyter/notebook
# # # repo at : https://github.com/jupyter/notebook

MAINTAINER Marco Zocca, zocca.marco gmail 


# # # environment variables
ENV PYMOL_VERSION 1.8.2.0
ENV USER nb


ENV IPYNBS_DIR /home/${USER}/scripts/iPyMol
ENV DL_DIR /home/dl

# # useful directories
RUN mkdir -p ${IPYNBS_DIR}
RUN mkdir -p ${DL_DIR}

# # scripts and datasets

ADD ipymol/ ${IPYNBS_DIR}



# # # update APT index
RUN apt-get update 

# # # install some build tools
RUN apt-get install -y sudo wget curl make python3 python3-dev python-pip pkg-config

# # # use bash rather than sh
RUN rm /bin/sh && ln -s /bin/bash /bin/sh




# # # PyMol, iPyMol dependencies
RUN apt-get install -y build-essential freeglut3 freeglut3-dev libpng3 libpng12-dev libpng-dev libfreetype6 libfreetype6-dev pmw glew-utils libglew-dev libxml2-dev   python3-scipy python3-nose    libtiff4-dev libjpeg8-dev zlib1g-dev liblcms2-dev libwebp-dev tcl8.5-dev tk8.5-dev python-tk



# # # # PyMol
WORKDIR ${DL_DIR}
RUN wget --no-verbose https://sourceforge.net/projects/pymol/files/pymol/1.8/pymol-v${PYMOL_VERSION}.tar.bz2
RUN tar jxf pymol-v${PYMOL_VERSION}.tar.bz2
RUN rm pymol-v*
WORKDIR pymol
RUN python3 setup.py build install

# RUN which pymol


# # # # iPyMol + dependencies
RUN pip3 install git+https://github.com/ocramz/ipymol.git@python3



# # # clean temp data
RUN sudo apt-get clean && apt-get purge && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*



## check installation
RUN pip list






EXPOSE 8888


# # working directory
WORKDIR /home/${USER}

VOLUME /home/${USER}


ENTRYPOINT ["tini", "--"]
CMD ["jupyter", "notebook", "--no-browser"]


# docker run --rm -it -p 8888:8888 ocramz/jupyter-docker-pymol