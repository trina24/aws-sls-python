FROM ubuntu:latest
RUN apt-get update && apt-get install -y python3 python3-pip jq curl \
&& pip3 install --upgrade awscli \
&& curl -sL https://deb.nodesource.com/setup_12.x | bash - \
&& apt-get install -y nodejs \
&& npm config set unsafe-perm true \
&& npm -g install serverless
