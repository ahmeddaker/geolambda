#!/bin/bash

VERSION=$(cat VERSION)
PYVERSION=$(cat python/PYVERSION)

docker build . -t ahmeddaker/geolambda:${VERSION}
docker run --rm -v $PWD:/home/geolambda -it ahmeddaker/geolambda:${VERSION} package.sh

cd python
docker build . --build-arg VERSION=${VERSION} -t ahmeddaker/geolambda:${VERSION}-python
docker run -v ${PWD}:/home/geolambda -t ahmeddaker/geolambda:${VERSION}-python package-python.sh

docker run -e GDAL_DATA=/opt/share/gdal -e PROJ_LIB=/opt/share/proj \
    --rm -v ${PWD}/lambda:/var/task lambci/lambda:python3.10 lambda_function.lambda_handler '{}'
