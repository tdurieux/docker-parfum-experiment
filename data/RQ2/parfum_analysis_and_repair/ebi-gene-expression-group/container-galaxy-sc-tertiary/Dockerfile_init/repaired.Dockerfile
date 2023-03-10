FROM quay.io/ebigxa/galaxy-init-base-docker-galaxy-stable:19.05-dev

MAINTAINER EBI Expression Atlas Team <gene-expression@ebi.ac.uk>

LABEL Description="Hinxton Single Cell Interactive Analysis Environment"
LABEL software="Galaxy Init"
LABEL software.version="19.05-dev"
LABEL version="1.1.0"


RUN virtualenv venv-workflow && \
    /bin/bash -c "source venv-workflow/bin/activate && \
                  pip install 'pip>=8.1' && \
                  pip install urllib3[secure] && \
                  pip install ephemeris==0.9.0 && \
                  deactivate && \
                  virtualenv --relocatable venv-workflow"

COPY config/job_conf.xml config/job_conf.xml
COPY config/tool_conf.xml config/tool_conf.xml
COPY config/container_resolvers_conf.xml config/container_resolvers_conf.xml
COPY config/sanitize_whitelist.txt config/sanitize_whitelist.txt
COPY tools tools

# Reqs/limits
COPY config/job_resource_params_conf.xml config/job_resource_params_conf.xml
COPY config/phenomenal_tools2container.yaml config/phenomenal_tools2container.yaml
COPY rules/k8s_destinations.py /galaxy-central/lib/galaxy/jobs/rules/k8s_destination.py

# Galaxy tours which guide users through the subsequent steps in an analysis
# COPY config/plugins/tours/*.yaml config/plugins/tours/

# Patches
COPY patches/kubernetes.py lib/galaxy/jobs/runners/kubernetes.py

COPY html/welcome_embl_ebi_rgb_2018.png welcome/welcome_embl_ebi_rgb_2018.png
COPY html/welcome_sanger_RGB_Full_Colour_landscape.png welcome/welcome_sanger_RGB_Full_Colour_landscape.png
COPY html/welcome.html welcome/welcome.html

COPY workflows workflows_to_load
COPY post-start-actions.sh post-start-actions.sh
RUN chmod u+x post-start-actions.sh