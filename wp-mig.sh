#!/bin/bash

gem install sequel fileutils safe_yaml unidecode mysql2 htmlentities

ruby -rrubygems -e 'require "jekyll-import";'\
'    JekyllImport::Importers::WordPress.run({'\
'      "dbname"   => "WORDPRESS",'\
'      "user"     => "wordpress",'\
'      "password" => "sKo-YutbffffstpekU5QdQFHVL",'\
'      "host"     => "127.0.0.1",'\
'      "port"     => "3306",'\
'      "socket"   => "",'\
'      "table_prefix"   => "wp_",'\
'      "site_prefix"    => "",'\
'      "clean_entities" => true,'\
'      "comments"       => true,'\
'      "categories"     => true,'\
'      "tags"           => true,'\
'      "more_excerpt"   => true,'\
'      "more_anchor"    => true,'\
'      "extension"      => "html",'\
'      "status"         => ["publish"]'\
'    })'

find _posts/ -mindepth 1 -exec sed -i '/status/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/wordpress_id/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/wordpress_url/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/published/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/author_login/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/author_email/d' {} \;
find _posts/ -mindepth 1 -exec sed -i '/author_url/d' {} \;
find _posts/ -mindepth 1 -exec sed -i "/date: '/d" {} \;
find _posts/ -mindepth 1 -exec sed -i "/date_gmt: '/d" {} \;

find _posts/ -mindepth 1 -exec sed -i "/author:/d" {} \;
find _posts/ -mindepth 1 -exec sed -i "/display_name:/d" {} \;
find _posts/ -mindepth 1 -exec sed -i "/login:/d" {} \;
find _posts/ -mindepth 1 -exec sed -i "/email:/d" {} \;
find _posts/ -mindepth 1 -exec sed -i "/url:/d" {} \;
