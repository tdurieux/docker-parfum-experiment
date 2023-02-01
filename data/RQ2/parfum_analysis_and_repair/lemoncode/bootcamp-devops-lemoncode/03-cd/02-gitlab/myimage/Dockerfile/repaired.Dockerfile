ARG base_version
ARG base_image_name
FROM $base_image_name:$base_version
ARG python_version
RUN echo $python_version
RUN apt-get update && apt-get install --no-install-recommends -y python$python_version && rm -rf /var/lib/apt/lists/*;
