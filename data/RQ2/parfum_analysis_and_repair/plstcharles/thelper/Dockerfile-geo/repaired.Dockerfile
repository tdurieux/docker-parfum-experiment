# use a generic tag easily reference base image, override actual tag with specific docker build
FROM thelper:base

# override base thelper
LABEL name="thelper-geo"
LABEL description.geo="Adds geospatial related packages to run machine learning projects with geo-referenced imagery"

# fix logged warning from GDAL sub-package when accessing Sentinel data via SAFE.ZIP
#   only problematic here when using the 'root' conda env
#   normal user installation with conda activation configures everything correctly
# (https://github.com/conda-forge/gdal-feedstock/issues/83#issue-162911573)
ENV CPL_ZIP_ENCODING=UTF-8

# everything already configured/copied by base thelper
# don't change directory to remain on specified workdir in base image
# only add extra geo packages
RUN sed -i 's/thelper/base/g' ${THELPER_HOME}/conda-env-geo.yml
RUN conda env update --file ${THELPER_HOME}/conda-env-geo.yml \
    && conda clean --all -f -y

# note: command is the same as base thelper