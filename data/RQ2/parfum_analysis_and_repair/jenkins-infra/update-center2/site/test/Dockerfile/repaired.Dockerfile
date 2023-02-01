# Test image only containing the generated .htaccess file with redirects
FROM httpd:2.4

# It's the default file except we AllowOverride All, and enable mod_rewrite