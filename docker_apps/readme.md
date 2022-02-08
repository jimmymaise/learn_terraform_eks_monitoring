aws ecr get-login-password \
--region us-west-2 \
| docker login \
--username AWS \
--password-stdin 604787518005.dkr.ecr.us-west-2.amazonaws.com

docker build -t 604787518005.dkr.ecr.us-west-2.amazonaws.com/prod-ecr-quote-fe-v1 ./quote_fe_v1

docker push 604787518005.dkr.ecr.us-west-2.amazonaws.com/prod-ecr-quote-fe-v1

docker build -t 604787518005.dkr.ecr.us-west-2.amazonaws.com/prod-ecr-quote-fe-v2 ./quote_fe_v2

docker push 604787518005.dkr.ecr.us-west-2.amazonaws.com/prod-ecr-quote-fe-v2