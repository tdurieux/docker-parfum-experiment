FROM {{ docker_test_image_busybox }}
# This should fail building if docker cannot resolve some-custom-host
RUN ping -c1 some-custom-host