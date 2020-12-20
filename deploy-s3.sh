#!/usr/bin/env bash

echo 'Deploying to AWS ...'

aws s3 sync ./dist/ s3://bounties.perp.fi/ --include "*" --exclude ".DS_Store" --region us-west-1 --acl public-read --cache-control 'no-store' --profile perpStaticWeb
if [ "$?" != 0 ]; then
    echo 'Deploy error'
    exit 2
fi

curl https://discordapp.com/api/webhooks/716481295789719553/Fjce30XaQg8EZMP2lu8NXx_ksoRSl0rzUoF7hJRVtxJhsmfrGyUOQXKZNreWkmqWLFZ7 \
  -H "Content-Type: application/json" \
  -X POST \
  -d '{"content": "[bounties.per.fi] deployed"}'

echo 'Done ...'
