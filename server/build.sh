#!/usr/bin/env bash

docker build -t invoiceninja:php-72 -f Dockerfile .
docker image ls invoiceninja:php-72