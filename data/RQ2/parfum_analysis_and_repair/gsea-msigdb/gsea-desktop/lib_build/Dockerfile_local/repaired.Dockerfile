FROM genepattern/docker-openjdk_11\:0.1
RUN set -o pipefail && mkdir -p /opt/gsea/GSEA_4.2.3
ADD GSEA-dist /opt/gsea/GSEA_4.2.3