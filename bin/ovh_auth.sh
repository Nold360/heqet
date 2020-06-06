#!/bin/bash
source bin/params.sh

if [ -z "$OVH_APPLICATION_KEY" ] && [ -z "$OVH_APPLICATION_SECRET" ] ; then
	echo "Create App & Enter Keys: https://eu.api.ovh.com/createApp/"
	read -p"Application Key: " OVH_APPLICATION_KEY
	read -p"Application Secret: " OVH_APPLICATION_SECRET
fi

# Generate Consumer Key:
if [ -z "${OVH_CONSUMER_KEY}" ] ; then
	curl -XPOST -H "X-Ovh-Application: $OVH_APPLICATION_KEY" -H "Content-type: application/json" https://eu.api.ovh.com/1.0/auth/credential -d '{
  	"accessRules": [
    	{
      	"method": "GET",
      	"path": "/domain/zone"
    	},
    	{
      	"method": "GET",
      	"path": "/domain/zone/*/record"
    	},
    	{
      	"method": "GET",
      	"path": "/domain/zone/*/record/*"
    	},
    	{
      	"method": "POST",
      	"path": "/domain/zone/*/record"
    	},
    	{
      	"method": "DELETE",
      	"path": "/domain/zone/*/record/*"
    	},
    	{
      	"method": "POST",
      	"path": "/domain/zone/*/refresh"
    	}
  	],
  	"redirection":"https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/ovh.md#creating-ovh-credentials"
	}' | jq .

	echo
	read -p"Please open the Validation URL & Enter Consumer Key: " OVH_CONSUMER_KEY
fi

echo
echo "Testing Credentials..."
curl 	-H "X-Ovh-Application:$OVH_APPLICATION_KEY" \
			-H "X-Ovh-Timestamp:$(curl -q https://eu.api.ovh.com/1.0/auth/time)" \
			-H "X-Ovh-Consumer:$OVH_CONSUMER_KEY" \
			-q https://eu.api.ovh.com/1.0/domain/ | jq

if [ "$?" != "0" ] ; then
  echo "Damn, testing credentials failed :("
  exit 1
fi

echo "Did it work?!"

read -p"Press Enter to create sealed secret..."
echo "Fetching Kubeseal Certificate..."
if ! kubeseal $KUBESEAL_ARGS --fetch-cert -n sealed-secrets > kubeseal-cert.pem ; then
	echo "Kubeseal failed fetching the certificate from the cluster.. :("
  exit 2
fi

echo "Creating Sealed Secret..."
kubectl create secret generic external-dns-auth \
    --from-literal=OVH_APPLICATION_KEY=$(echo -n "$OVH_APPLICATION_KEY") \
    --from-literal=OVH_APPLICATION_SECRET=$(echo -n "$OVH_APPLICATION_SECRET") \
    --from-literal=OVH_CONSUMER_KEY=$(echo -n "$OVH_CONSUMER_KEY") \
    --namespace=external-dns \
    --dry-run=client -o yaml > sec.yaml

cat sec.yaml | kubeseal ${KUBESEAL_ARGS} -n external-dns --cert=kubeseal-cert.pem | tee templates/sealedsecret-external-dns.yaml

echo "Done. "
