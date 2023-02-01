# The way to aggregate kernel drivers leaves an image with a large number of layers.
# In order to squash them down to just a couple, (without using experimental features),
# We grab the aggregated image and copy the files we need onto a fresh UBI image.