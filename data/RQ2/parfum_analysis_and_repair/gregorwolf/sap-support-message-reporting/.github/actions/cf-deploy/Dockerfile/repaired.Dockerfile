# Borrowed from https://github.com/SAP-samples/cap-sflight
FROM ppiper/cf-cli:v11

# needed for cf to find its config
# (GH resets HOME to /github/workspace)