# Test to make sure the cache works with special file permissions properly.
# If the image is built twice, directory foo should have the sticky bit,
# and file bar should have the setuid and setgid bits.