# Devops rDod Image
# Using Developer rDoD Image as base
FROM mderasse/rdod:developer

LABEL maintainer="Matthieu DERASSE <github@derasse.fr>"

# Back to Root
USER 0

# Configure devops System
COPY devops.yml /opt/rdod/custom/install.yml
COPY roles/golang /opt/rdod/custom/roles/golang
COPY roles/packer /opt/rdod/custom/roles/packer
COPY roles/python /opt/rdod/custom/roles/python
COPY roles/perl /opt/rdod/custom/roles/perl
COPY roles/terraform /opt/rdod/custom/roles/terraform

# Launching System Installation
RUN ansible-playbook /opt/rdod/custom/install.yml

# Back to User