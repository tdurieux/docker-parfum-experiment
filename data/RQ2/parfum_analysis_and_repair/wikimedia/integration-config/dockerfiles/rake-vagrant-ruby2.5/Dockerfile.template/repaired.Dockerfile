FROM {{ "rake-ruby2.5" | image_tag }}

USER root
RUN {{ "rsync zlib1g-dev" | apt_install }}

USER nobody