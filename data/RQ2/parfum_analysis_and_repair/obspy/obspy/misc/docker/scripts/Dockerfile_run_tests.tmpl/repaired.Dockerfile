FROM obspy:{{IMAGE_NAME}}

MAINTAINER Lion Krischer

ADD install_and_run_tests_on_image.sh install_and_run_tests_on_image.sh
ADD obspy /obspy
RUN echo {{IMAGE_NAME}} > container_name.txt
CMD ["/bin/bash", "install_and_run_tests_on_image.sh"{{EXTRA_ARGS}}]