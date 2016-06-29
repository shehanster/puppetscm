#!/bin/bash

CHECKIN_DIR=/ebs/jenkins/var/lib/jenkins/workspace/Checkout_latest_puppet/puppet-orchestration/
PUPPET_ENV_DIR=/etc/puppet/environments
LOG_FILE=/tmp/puppet-deply.log
PUPPET_CONF_DIR=/etc/puppet

logging () {
	sudo echo "$(date) - $@"
}

deploy_env () {
	ENV_NAME=$1
	sudo mkdir -p $PUPPET_ENV_DIR/$ENV_NAME/bin/

	sudo cp -a -v -f $CHECKIN_DIR/environments/$ENV_NAME/bin/module-install.sh $PUPPET_ENV_DIR/$ENV_NAME/bin/

	logging "[INFO] Installing Modules for $ENV_NAME"

	cd $PUPPET_ENV_DIR/$ENV_NAME/bin/
	sudo sh module-install.sh
        
        sudo cp -a -v -f $CHECKIN_DIR/environments/$ENV_NAME/manifests $PUPPET_ENV_DIR/$ENV_NAME/
        sudo cp -a -v -f $CHECKIN_DIR/environments/$ENV_NAME/files $PUPPET_ENV_DIR/$ENV_NAME/

}

cd $CHECKIN_DIR/environments

DIR_LIST=$(ls)

for i in $DIR_LIST
do
	deploy_env $i
done

logging "[INFO] Deployment completed !!"


