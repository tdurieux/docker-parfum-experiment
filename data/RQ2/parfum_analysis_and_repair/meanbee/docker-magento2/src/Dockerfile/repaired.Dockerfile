#
# {{generated_by_builder}}
#

FROM <?php printf("php:%s-%s\n", $version, $flavour) ?>

MAINTAINER Nick Jones <nick@nicksays.co.uk>
<?php
    $versionSpecificPackages = [];

    if (version_compare($version, '7.3', '>=')) {
        $versionSpecificPackages[] = 'libzip-dev';
    }

    if (version_compare($version, '7.4', '>=')) {
        $versionSpecificPackages[] = 'libonig-dev';
    }

    $packages = array_merge([
        'libfreetype6-dev',
        'libicu-dev',
        'libjpeg62-turbo-dev',
        'libmcrypt-dev',
        'libpng-dev',
        'libxslt1-dev',
        'sendmail-bin',
        'sendmail',
        'sudo'
    ], $imageSpecificPackages ?? [], $versionSpecificPackages ?? []);
?>

# Install dependencies
RUN apt-get update \
  && apt-get install -y \
    <?php echo join(" \\ \n    ", $packages) ?>


# Configure the gd library
<?php if (version_compare($version, '7.3', '<=')): ?>
RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/
<?php else: ?>
RUN docker-php-ext-configure \
  gd --with-freetype --with-jpeg
<?php endif ?>

# Install required PHP extensions
<?php $phpExtensions = array_merge([
  'dom',
  'gd',
  'intl',
  'mbstring',
  'pdo_mysql',
  'xsl',
  'zip',
  'soap',
  'bcmath',
  'pcntl',
  'sockets'
], $imageSpecificPhpExtensions ?? []);
?>

RUN docker-php-ext-install \
  <?php echo join(" \\ \n  ", $phpExtensions) ?>


# Install Xdebug (but don't enable)