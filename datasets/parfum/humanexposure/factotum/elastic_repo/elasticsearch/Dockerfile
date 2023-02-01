FROM elasticsearch:7.16.1

# Add files
COPY chemical_synonyms.txt /usr/share/elasticsearch/config/

# Fix file permissions
USER root
RUN chown elasticsearch:root /usr/share/elasticsearch/config/chemical_synonyms.txt \
 && chmod 644 /usr/share/elasticsearch/config/chemical_synonyms.txt

USER elasticsearch
