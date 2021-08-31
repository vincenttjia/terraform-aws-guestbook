#!/bin/bash
echo "" >> ${env_path}
echo DB_CONNECTION=mysql >> ${env_path}
echo DB_HOST=${DbHost} >> ${env_path}
echo DB_PORT=3306 >> ${env_path}
echo DB_DATABASE=${DBName} >> ${env_path}
echo DB_USERNAME=${MyDBUsername} >> ${env_path}
echo DB_PASSWORD=${MyDBPassword} >> ${env_path}
echo "" >> ${env_path}
echo REDIS_HOST=${RedisHost} >> ${env_path}
echo REDIS_PASSWORD=null >> ${env_path}
echo REDIS_PORT=6379 >> ${env_path}
echo "" >> ${env_path}
echo AWS_COGNITO_KEY=${AwsCognitoKey} >> ${env_path}
echo AWS_COGNITO_SECRET=${AwsCognitoSecret} >> ${env_path}
echo AWS_COGNITO_REGION=${AwsCognitoRegion} >> ${env_path}
echo AWS_COGNITO_CLIENT_ID=${AwsCognitoClientId} >> ${env_path}
echo AWS_COGNITO_CLIENT_SECRET=${AwsCognitoClientSecret} >> ${env_path}
echo AWS_COGNITO_USER_POOL_ID=${AwsCognitoUserPoolId} >> ${env_path}
echo AWS_COGNITO_DELETE_USER=${AwsCognitoDeleteUser} >> ${env_path}
echo "" >> ${env_path}
echo USE_SSO=true >> ${env_path}
mkdir /certs/
wget https://truststore.pki.rds.amazonaws.com/us-east-1/us-east-1-bundle.pem -O /certs/ca.pem
chmod 755 /certs/ca.pem