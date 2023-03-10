FROM centos:7

# Ensure that everything subsequent is re-run when a new revision is
# being built (rather than being cached) - so as to avoid potential
# mismatches between results of yum update and the package dependency
# installation itself
RUN echo [[REVISION]]

RUN yum -y update
RUN yum -y install wget && rm -rf /var/cache/yum
ADD output/SonicAnnotator-[[REVISION]]-x86_64.AppImage runner.AppImage
RUN chmod +x runner.AppImage
RUN ./runner.AppImage --appimage-extract
RUN ./squashfs-root/AppRun --version
