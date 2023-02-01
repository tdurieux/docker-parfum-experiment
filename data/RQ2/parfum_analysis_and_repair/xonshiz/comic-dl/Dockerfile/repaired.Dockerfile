# build with command:
# docker build -t comic-dl:py3.8-buster .
# run with alias
# alias comic_dl="docker run -it --rm -e PGID=$(id -g) -e PUID=$(id -u) -v $(pwd):/directory:rw -w /directory comic-dl:py3.8-buster comic_dl -dd /directory"

# for armv7,
# cross build it (it takes a few hours on x86_64)
# build with command:
# docker build -t comic-dl:py3.8-buster-armv7 --platform linux/arm/v7 .
# export with command
# docker save -o comic-dl.tar comic-dl:py3.8-buster-armv7
# import on arm machine with command:
# docker load --input comic-dl.tar
# run with alias:
# alias comic_dl="docker run -it --rm -e PGID=$(id -g) -e PUID=$(id -u) -v $(pwd):/directory:rw -w /directory comic-dl:py3.8-buster-armv7 comic_dl -dd /directory"