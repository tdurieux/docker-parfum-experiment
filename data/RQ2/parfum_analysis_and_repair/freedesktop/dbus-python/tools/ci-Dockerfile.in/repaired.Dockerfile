FROM @ci_docker@
ENV container docker

ADD tools/ci-install.sh /ci-install.sh
RUN ci_suite="@ci_suite@" ci_distro="@ci_distro@" ci_in_docker=yes dbus_ci_system_python="@dbus_ci_system_python@" /ci-install.sh

ADD . /home/user/ci
RUN chown -R user:user /home/user/ci
WORKDIR /home/user/ci
USER user