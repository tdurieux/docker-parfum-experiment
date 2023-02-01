FROM {{cookiecutter.repo_name}}-base
RUN curl -f -sL https://deb.nodesource.com/setup_4.x | bash -
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
       apt-get install -y --force-yes --no-install-recommends nodejs && rm -rf /var/lib/apt/lists/*;

WORKDIR /react/
