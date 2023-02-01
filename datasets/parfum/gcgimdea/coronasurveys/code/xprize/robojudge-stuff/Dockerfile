FROM ubuntu:latest

ARG ssh_prv_key
ARG ssh_pub_key

ENV HOME_DIR=/home/xprize

# Create an xprize user
RUN useradd -ms /bin/bash -d ${HOME_DIR} -u 1000 xprize \
    && echo xprize:pw | chpasswd

WORKDIR $HOME_DIR

# install cron
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Paris

RUN apt-get update && apt-get install -y --no-install-recommends build-essential r-base r-cran-randomforest python3 cron python3-pip python3-setuptools python3-dev libssl-dev libcurl4-openssl-dev libxml2-dev git openssh-client openssh-server less emacs


RUN cd /usr/bin ; ln -s python3 python; ln -s pip3 pip; cd $HOME_DIR



RUN Rscript -e "install.packages('pacman')"
RUN Rscript -e "pacman::p_load(dplyr,ggplot2,httr,jsonlite,stringr,data.table,lubridate,tidyverse,reticulate)"


# Authorize SSH Host
RUN mkdir -p /home/xprize/.ssh && \
    chmod 0700 /home/xprize/.ssh && \
    ssh-keyscan github.com > /home/xprize/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /home/xprize/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /home/xprize/.ssh/id_rsa.pub && \
    chown -R xprize. /home/xprize/.ssh/ && \
    chmod 600 /home/xprize/.ssh/id_rsa && \
    chmod 600 /home/xprize/.ssh/id_rsa.pub

RUN su - xprize -c "git clone git@github.com:GCGImdea/coronasurveys.git"

RUN su - xprize -c "git clone git@github.com:leaf-ai/covid-xprize-robotasks.git covid-xprize-robotasks-main"

RUN su - xprize -c "git clone git@github.com:leaf-ai/covid-xprize.git"

RUN su - xprize -c "cd ; ln -s  ~/coronasurveys/code/xprize/cs-prescribe-daily work"

#RUN su - xprize -c "cd coronasurveys/code/xprize/cs-prescribe-daily;  patch  prescribe.py -i patch-prescribe.patch ; cd"

RUN su - xprize -c "cd coronasurveys/code/xprize/cs-prescribe-daily; pip3 install -r requirements.txt"

RUN su - xprize -c "cd coronasurveys/code/xprize/cs-prescribe-daily; pip3 install -e ~/covid-xprize"




# Create the log file to be able to run tail
RUN touch /tmp/cron.log && chown xprize:xprize /tmp/cron.log

# /tasks is mounted at run time. Set up cron job, run cron, then drop down to unprivileged user 'xprize'
#CMD $HOME_DIR/tasks/entrypoint.sh && cron && su --login xprize

EXPOSE 22

#RUN su - xprize -c "cd coronasurveys/code/xprize;  patch  prescribe.py -i patch-prescribe.patch ; cd"

CMD su - xprize -c "cd $HOME_DIR/coronasurveys/code/xprize; ./robojudge-stuff/prescribe_concatenate_predict.sh $HOME_DIR/covid-xprize-robotasks-main/ $HOME_DIR/coronasurveys > out.txt 2>&1"
# ["R"]