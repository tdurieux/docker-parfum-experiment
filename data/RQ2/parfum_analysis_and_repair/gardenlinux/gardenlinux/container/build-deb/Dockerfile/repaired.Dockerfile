ARG build_base_image=gardenlinux/build
FROM	$build_base_image

RUN sudo apt-get update \
     && sudo apt-get install --no-install-recommends -y devscripts && rm -rf /var/lib/apt/lists/*;

