# escape=`

ARG base_image
FROM ${base_image}

COPY mesa_deps_test.ps1 C:\
RUN C:\mesa_deps_test.ps1