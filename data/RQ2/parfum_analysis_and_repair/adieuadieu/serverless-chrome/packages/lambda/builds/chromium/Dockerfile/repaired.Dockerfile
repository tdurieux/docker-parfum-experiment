#
# Launch headless Chromium with:
# docker run -d --rm --name headless-chromium -p 9222:9222 adieuadieu/headless-chromium-for-aws-lambda
#

#FROM amazonlinux:2017.03
FROM lambci/lambda

# ref: https://chromium.googlesource.com/chromium/src.git/+refs