#!/bin/bash

mkdir mibank_django_project
cp -r ../mibank_django_project/* mibank_django_project
docker-compose build --no-cache
rm -rf mibank_django_project
