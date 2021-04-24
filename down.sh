docker-compose -f ./artifacts/channel/create-certificate-with-ca/docker-compose.yaml down
docker-compose -f ./artifacts/docker-compose.yaml down

docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)