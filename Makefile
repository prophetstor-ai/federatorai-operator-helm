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
