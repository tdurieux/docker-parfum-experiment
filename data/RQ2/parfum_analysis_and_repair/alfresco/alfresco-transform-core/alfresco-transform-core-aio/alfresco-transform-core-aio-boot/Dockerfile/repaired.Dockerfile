# Image provides an all-in-one (AIO) container in which to run core transformations for Alfresco Content Services.

# Tika is from Apache. See the license at http://www.apache.org/licenses/LICENSE-2.0.
# LibreOffice is from The Document Foundation. See the license at https://www.libreoffice.org/download/license/ or in /libreoffice.txt.
# ImageMagick is from ImageMagick Studio LLC. See the license at http://www.imagemagick.org/script/license.php or in /ImageMagick-license.txt.
# alfresco-pdf-renderer uses the PDFium library from Google Inc. See the license at https://pdfium.googlesource.com/pdfium/+/master/LICENSE or in /pdfium.txt.

FROM alfresco/alfresco-base-java:jre11-centos7-202205121725

ARG EXIFTOOL_VERSION=12.25
ARG EXIFTOOL_FOLDER=Image-ExifTool-${EXIFTOOL_VERSION}
ARG EXIFTOOL_URL=https://nexus.alfresco.com/nexus/service/local/repositories/thirdparty/content/org/exiftool/image-exiftool/${EXIFTOOL_VERSION}/image-exiftool-${EXIFTOOL_VERSION}.tgz

ARG IMAGEMAGICK_VERSION=7.1.0-16
ENV IMAGEMAGICK_RPM_URL=https://nexus.alfresco.com/nexus/service/local/repositories/thirdparty/content/org/imagemagick/imagemagick-distribution/${IMAGEMAGICK_VERSION}/imagemagick-distribution-${IMAGEMAGICK_VERSION}-centos7.rpm
ENV IMAGEMAGICK_LIB_RPM_URL=https://nexus.alfresco.com/nexus/service/local/repositories/thirdparty/content/org/imagemagick/imagemagick-distribution/${IMAGEMAGICK_VERSION}/imagemagick-distribution-${IMAGEMAGICK_VERSION}-libs-centos7.rpm
ENV IMAGEMAGICK_DEP_RPM_URL=https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

ARG LIBREOFFICE_VERSION=7.2.5
ENV LIBREOFFICE_RPM_URL=https://nexus.alfresco.com/nexus/service/local/repositories/thirdparty/content/org/libreoffice/libreoffice-dist/${LIBREOFFICE_VERSION}/libreoffice-dist-${LIBREOFFICE_VERSION}-linux.gz

ENV ALFRESCO_PDF_RENDERER_LIB_RPM_URL=https://nexus.alfresco.com/nexus/service/local/repositories/releases/content/org/alfresco/alfresco-pdf-renderer/1.1/alfresco-pdf-renderer-1.1-linux.tgz

ENV JAVA_OPTS=""

# Set default user information