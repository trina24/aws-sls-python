# aws-sls-python
Ubuntu-based Docker image with Python 3, aws-cli and serverless framework 

### Use case
This image allows to deploy Python applications based on [serverless framework](https://serverless.com/framework/) to AWS.

Using Ubuntu image as base solves the issue with installing Python packages for Lambda functions. Some packages (like [psycopg2](https://pypi.org/project/psycopg2/)) installed on Alpine-based images are not working properly on Amazon Linux, which causes Lambda functions to throw errors.

### Example

Following code can be used to create a pipeline for [GitLab CI/CD](https://docs.gitlab.com/ee/ci/) EC2 runner that is allowed to assume IAM deployment role.

```yaml
image: trina24/aws-sls-python:latest

stages:
  - deploy

before_script:
  - ROLE=$(aws sts assume-role --role-arn $DEPLOYMENT_ROLE_ARN --role-session-name $ROLE_SESSION_NAME)
  - export AWS_ACCESS_KEY_ID=$(echo $ROLE | jq .Credentials.AccessKeyId | xargs)
  - export AWS_SECRET_ACCESS_KEY=$(echo $ROLE | jq .Credentials.SecretAccessKey | xargs)
  - export AWS_SESSION_TOKEN=$(echo $ROLE | jq .Credentials.SessionToken | xargs)

.job_template: &deploy
  stage: deploy
  script:
    - sls plugin install -n serverless-python-requirements
    - sls deploy --stage $STAGE

deploy-dev:
  except:
    - master
  variables:
    STAGE: dev
  <<: *deploy

deploy-prod:
  only:
    - master
  variables:
    STAGE: prod
  <<: *deploy

```