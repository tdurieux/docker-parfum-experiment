# Package to build
packages/*
!packages/api
!packages/www

# General git and node frameworks files
.git
.github
.cache
**/node_modules
**/coverage
**/yarn-error.log
**/.next

# API-specific
*/*/minio
*/*/dist
*/*/docs

# WWW-specific
*/*/.next
*/*/out

# So you can change this without forcing a rebuild