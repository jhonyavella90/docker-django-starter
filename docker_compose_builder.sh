#!/bin/bash

mkdir mibank_django_project
mkdir mibank_mobileapp
cp -r ../mibank_django_project/* mibank_django_project
cp -r ../mibank_mobileapp/* mibank_mobileapp
docker-compose build --no-cache
rm -rf mibank_django_project
rm -rf mibank_mobileapp
