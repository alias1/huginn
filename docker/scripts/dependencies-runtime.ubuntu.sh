#!/usr/bin/env sh
set -ex

# TODO: This was copied verbatim from the old 'prepare' script. It should be refactored to separate build deps from runtime deps

cat > /etc/dpkg/dpkg.cfg.d/01_nodoc <<EOF
# Delete locales
path-exclude=/usr/share/locale/*

# Delete man pages
path-exclude=/usr/share/man/*

# Delete docs
path-exclude=/usr/share/doc/*
path-include=/usr/share/doc/*/copyright
EOF

export LC_ALL=C
export DEBIAN_FRONTEND=noninteractive

minimal_apt_get_install='apt-get install -y --no-install-recommends'

apt-get update
apt-get dist-upgrade -y --no-install-recommends

$minimal_apt_get_install software-properties-common

add-apt-repository -y ppa:brightbox/ruby-ng

apt-get update
$minimal_apt_get_install build-essential checkinstall git-core \
  zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev \
  libncurses5-dev libffi-dev libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev \
  graphviz libgraphviz-dev \
  libmysqlclient-dev libpq-dev libsqlite3-dev \
  ruby2.3 ruby2.3-dev

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

gem install --no-ri --no-rdoc bundler
