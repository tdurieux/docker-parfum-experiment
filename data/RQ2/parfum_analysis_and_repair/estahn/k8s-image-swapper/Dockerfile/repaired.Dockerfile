#FROM quay.io/skopeo/stable:v1.2.0 AS skopeo
#FROM gcr.io/distroless/base-debian10
#FROM debian:10
#COPY --from=skopeo /usr/bin/skopeo /skopeo

# TODO: Using alpine for now due to easier installation of skopeo
#       Will use distroless after incorporating skopeo into the webhook directly