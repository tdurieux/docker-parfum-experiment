# Dockerfile to create a smb server that is used by the get_smb.go tests
FROM dperson/samba

# Create shared folders
RUN mkdir -p /public && mkdir -p /private

# Create shared files and directories under the shared folders (data and mnt)