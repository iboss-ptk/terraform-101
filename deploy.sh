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
      -var 'channel_access_token=qBTqoQoF8N7usYfowsfZHjUaJ6lsS2S1S3iZ23qr+b2cqm5QDltqePqBHKn0H4f36QZfubq/MQdcu2ue/yRsUJkkWueEGp2HZcjRomVg6FXUcgTTlbCSQjaXuLzSHE10Z2pco4L5AEoOxBnGxGm5qQdB04t89/1O/w1cDnyilFU='
}


# pipeline

update_deployment_package
apply_infra
