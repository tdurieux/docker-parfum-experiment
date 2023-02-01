# ref: https://github.com/nuest/mro-docker/blob/master/3.4.0/Dockerfile
FROM lablup/kernel-python:3.6-ubuntu

# https://mran.revolutionanalytics.com/documents/rro/installation/#revorinst-lin
# Use major and minor vars to re-use them in non-interactive installation script
ENV MRO_VERSION_MAJOR 3
ENV MRO_VERSION_MINOR 4
ENV MRO_VERSION_BUGFIX 2
ENV MRO_VERSION $MRO_VERSION_MAJOR.$MRO_VERSION_MINOR.$MRO_VERSION_BUGFIX

# Install some useful tools and dependencies for MRO
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        # MRO dependencies that don't sort themselves out on their own:
        less \
        libgomp1 \
        libpango-1.0-0 \
        libxt6 \
        libsm6 \
    && rm -rf /var/lib/apt/lists/*

# Donwload and install MRO & MKL
RUN curl -LO -# https://mran.blob.core.windows.net/install/mro/$MRO_VERSION/microsoft-r-open-$MRO_VERSION.tar.gz \
    && tar -xzf microsoft-r-open-$MRO_VERSION.tar.gz \
    && cd microsoft-r-open \
    && ./install.sh -a -u \
    && cd .. \
    && rm -r microsoft-r-open

# Print EULAs on every start of R to the user, because they were accepted at image build time
COPY MKL_EULA.txt /home/sorna/MKL_EULA.txt
COPY MRO_EULA.txt /home/sorna/MRO_EULA.txt
RUN mkdir -p /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/
RUN echo 'cat("\n", readLines("/home/sorna/MKL_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site \
    && echo 'cat("\n", readLines("/home/sorna/MRO_EULA.txt"), "\n", sep="\n")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site

# Overwrite default behaviour to never save workspace, see https://mran.revolutionanalytics.com/documents/rro/reproducibility/doc-research/
RUN echo 'utils::assignInNamespace("q", function(save = "no", status = 0, runLast = TRUE) { \
     .Internal(quit(save, status, runLast)) }, "base") \
utils::assignInNamespace("quit", function(save = "no", status = 0, runLast = TRUE) { \
     .Internal(quit(save, status, runLast)) }, "base")' >> /usr/lib64/microsoft-r/$MRO_VERSION_MAJOR.$MRO_VERSION_MINOR/lib64/R/etc/Rprofile.site

COPY demo.R /home/sorna/demo.R

RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && apt-get update && apt-get install -y locales \
    && locale-gen en_US.utf8 \
    && /usr/sbin/update-locale LANG=en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8

# ARG VCS_URL
# ARG VCS_REF
# ARG BUILD_DATE

# # Add image metadata
# LABEL org.label-schema.license="https://mran.microsoft.com/faq/#licensing" \
#     org.label-schema.vendor="Microsoft Corporation, Dockerfile provided by Daniel Nüst" \
#     org.label-schema.name="Microsoft R Open" \
#     org.label-schema.description="Docker images of Microsoft R Open (MRO) with the Intel® Math Kernel Libraries (MKL)." \
#     org.label-schema.vcs-url=$VCS_URL \
#     org.label-schema.vcs-ref=$VCS_REF \
#     org.label-schema.build-date=$BUILD_DATE \
#     org.label-schema.schema-version="rc1" \
#     maintainer="Daniel Nüst <daniel.nuest@uni-muenster.de>"
# Install kernel-runner scripts package

LABEL io.sorna.features="query uid-match"

RUN pip install --no-cache-dir "backend.ai-kernel-runner[r]~=1.4.0"

ADD install-packages.R /home/sorna/install-packages.R
RUN Rscript /home/sorna/install-packages.R

# CMD ["/home/sorna/jail", "-policy", "/home/sorna/policy.yml", \
#      "/usr/local/bin/python", "-m", "ai.backend.kernel", "r"]
CMD ["/usr/local/bin/python", "-m", "ai.backend.kernel", "r"]
