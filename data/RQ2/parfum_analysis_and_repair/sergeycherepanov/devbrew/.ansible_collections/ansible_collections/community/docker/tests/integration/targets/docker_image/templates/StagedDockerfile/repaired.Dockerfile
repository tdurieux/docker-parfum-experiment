FROM {{ docker_test_image_busybox }} AS first
ENV dir /first
WORKDIR ${dir}

FROM {{ docker_test_image_busybox }} AS second
ENV dir /second
WORKDIR ${dir}