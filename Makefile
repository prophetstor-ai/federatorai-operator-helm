##
SOURCE_ROOT = $(shell readlink -m .)
TMP_DIR = $(SOURCE_ROOT)/tmp

##
HELM_CMD = docker run -ti --rm -v $(SOURCE_ROOT):/apps -v $(TMP_DIR)/.kube:/root/.kube -v $(TMP_DIR)/.helm:/root/.helm alpine/helm

#
all: build

build:
	@set -e; \
	$(HELM_CMD) package helm-chart-sources/*; \
	$(HELM_CMD) repo index .

clobber: clean

clean:
	@rm -rfv *~ $(TMP_DIR)
	@find $(SOURCE_ROOT) -name "*~" | while read fn; do rm -v $${fn}; done

test-server:
	@set -x; [ "${SERVER_HTTP}" = "" ] && export SERVER_HTTP=28080; \
	[ "${SERVER_HTTPS}" = "" ] && export SERVER_HTTPS=28443; set ; \
	/bin/echo -e "\nServer start on http port $${SERVER_HTTP} and https port $${SERVER_HTTPS}."; \
	/bin/echo -e "You can add helm repository with the following command."; \
	/bin/echo -e "  helm repo add prophetstor http://<my_server_ip>:$${SERVER_HTTP}/\n\n"; \
	docker run --rm -it \
	    -p $${SERVER_HTTP}:80 \
	    -p $${SERVER_HTTPS}:443 \
	    -v "`pwd`:/data" \
	    repo.prophetservice.com/nginx-here

upload-repo:
	tgz_file=federatorai-4.7.0.tgz; \
	curl -v -u builder:password http://repo.prophetservice.com:8081/repository/charts/ --upload-file $${tgz_file}
