# {{ distro_image_name }} pbench-server base image
FROM docker.io/library/{{ distro_image }}

# Install the appropriate pbench repository file for {{ distro_image_name }}.
COPY ./{{ pbench_repo_file }} /etc/yum.repos.d/pbench.repo

# Install the pbench-server RPM, which should have all its dependencies enumerated.