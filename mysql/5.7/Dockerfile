###
# fabioassuncao/docker-images
#
# Repository:    MySQL
# Image:         CLI/Base
# Version:       5.6
# Strategy:      Based on mysql:5.6
# Base distro:   debian:jessie
#
FROM mysql:5.7

MAINTAINER Fábio Assunção <fabio23gt@gmail.com>

# Laravel requirement for preventing migration timestamp incompatibility
COPY mode.cnf /etc/mysql/mysql.conf.d/mode.cnf
