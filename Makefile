.PHONY: init package

REGISTRY:=registry.crazyzone.be
NAME=web
VERSION=$(shell yq eval -j Chart.yaml | jq -r .version)
FULLVERSIONNAME=${REGISTRY}/${NAME}:${VERSION}
FULLLATESTNAME=${REGISTRY}/${NAME}:latest

init:
	export HELM_EXPERIMENTAL_OCI=1

save: init
	helm chart save . ${FULLVERSIONNAME}
	helm chart save . ${FULLLATESTNAME}

push: save
	helm chart push ${FULLVERSIONNAME}
	helm chart push ${FULLLATESTNAME}