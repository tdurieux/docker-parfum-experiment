# This can be built and pushed with
# cat aur-checker-Dockerfile | docker build -t "drud/arch-aur-builder:latest" - && docker push "drud/arch-aur-builder:latest"
# - Edit PKGBUILD to change the version and hash or anything else
# - Then run it with
# docker run --rm --mount type=bind,source=$(pwd),target=/tmp/ddev-bin --workdir=/tmp/ddev-bin drud/arch-aur-builder bash -c "makepkg --printsrcinfo > .SRCINFO && makepkg -s"
# Then `git add -u` and commit and push