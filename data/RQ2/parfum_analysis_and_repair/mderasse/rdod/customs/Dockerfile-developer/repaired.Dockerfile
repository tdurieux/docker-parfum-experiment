# Developer rDod Image
# Using Basic rDoD Image as base
FROM mderasse/rdod:latest

LABEL maintainer="Matthieu DERASSE <github@derasse.fr>"

# Back to Root
USER 0

# Configure Developer System
COPY developer.yml /opt/rdod/custom/install.yml
COPY roles/atom /opt/rdod/custom/roles/atom
COPY roles/postman /opt/rdod/custom/roles/postman
COPY roles/devtools /opt/rdod/custom/roles/devtools
COPY roles/geany /opt/rdod/custom/roles/geany
COPY roles/vscode /opt/rdod/custom/roles/vscode

# Launching System Installation
RUN ansible-playbook /opt/rdod/custom/install.yml

# Back to User