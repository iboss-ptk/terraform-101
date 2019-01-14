#!/bin/bash

set -e


update_deployment_package () {
    PACKAGE_DIR="deployment"
    PACKAGE_NAME="lambda.zip"
    PACKAGE_PATH="$PACKAGE_DIR/$PACKAGE_NAME"


    if [ ! -d $PACKAGE_DIR ]; then
        echo "deployment directory not found"
        echo "creating  $PACKAGE_DIR directory..."
        mkdir $PACKAGE_DIR
    fi

    if [ -f $PACKAGE_PATH ]; then
        echo "lambda zip found"
        echo "cleaning up $PACKAGE_PATH ..."
        rm -f $PACKAGE_PATH
    fi

    cp crush_bot/target/x86_64-unknown-linux-musl/release/crush_bot ./bootstrap
    zip $PACKAGE_PATH bootstrap
    rm -f bootstrap
    aws s3 cp $PACKAGE_PATH "s3://crush-lambda-deployment/$PACKAGE_NAME"
}

apply_infra () {
    echo "applying infrastructure..."
    cd infrastructure
    terraform apply -auto-approve \
      -var 'channel_access_token=yrJqaPr7RTT6c2RWtyzimvcf7WO9Kr/Hho+fXIN4oNSFdOcNCU+HGJZkJ8xUrvMTnAPOF6QKhda1nVJoTYvHwVl7sss/7PkMdqs8RRUmqjPxdichJKqAWMJe7P/0zqhxnGI2rJTqCy/2wXDyL7eGvQdB04t89/1O/w1cDnyilFU='
}


# pipeline

update_deployment_package
apply_infra
