#!/bin/bash

version=$1

# First we build the images
sudo docker build . -t  feldrise/isati-integration-app 

# The we add tag for version
sudo docker image tag feldrise/isati-integration-app:latest feldrise/isati-integration-app:$version

# Finally we push to Docker hub
sudo docker push feldrise/isati-integration-app:latest
sudo docker push feldrise/isati-integration-app:$version