#! /bin/bash
set -x #o # Remove flag o if the script is ready

S3Name="akinmoyero-gabriel"
S3Path=""
repositoryFile="repository.yaml"

read -p "Please enter your git username: " GIT_USER
read -s -p "Please enter your git password: " GIT_PASSWORD


for repository in $( yq e -o j -I 0 '.repositories[]' ${repositoryFile} ); do
    # echo $repository
    repositoryName=$( echo ${repository} | jq -r .name )
    repositoryURL=$( echo ${repository} | jq -r .url | sed "s?https://?https://${GIT_USER}:${GIT_PASSWORD}@?" )

    echo "Cloning repository ${repositoryName}"
    git clone ${repositoryURL} ${repositoryName}

    aws s3 cp ${repositoryName} s3://${S3Name}/${S3Path} --recursive --exclude ".git/*"
    rm -rf ${repositoryName}
done

# curl https://akingo7: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@api.github.com/orgs/darey-devops/repos | jq -r '.[].name'