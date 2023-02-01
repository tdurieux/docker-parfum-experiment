# Some geo dependencies (like rasterio) don't have wheels that work for M1
# macs. So this image includes gdal, as well as other dependicies needed to
# build those libraries from scratch.
#
# It works just the same as the main image, but is much larger and slower.