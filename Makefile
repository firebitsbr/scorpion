#---* Makefile *---#
.SILENT :

export GO111MODULE=on

# Base package
BASE_PACKAGE=github.com/qorpress

# App name
APPNAME=peaks-tires

# Go configuration
GOOS?=$(shell go env GOHOSTOS)
GOARCH?=$(shell go env GOHOSTARCH)

# Add exe extension if windows target
is_windows:=$(filter windows,$(GOOS))
EXT:=$(if $(is_windows),".exe","")
LDLAGS_LAUNCHER:=$(if $(is_windows),-ldflags "-H=windowsgui",)

# Archive name
ARCHIVE=$(APPNAME)-$(GOOS)-$(GOARCH).tgz

# Plugin name
PLUGIN?=scorpion

# Plugin filename
PLUGIN_SO=$(APPNAME)-$(PLUGIN).so

# Extract version infos
VERSION:=`git describe --tags --always`
GIT_COMMIT:=`git rev-list -1 HEAD --abbrev-commit`
BUILT:=`date`

## docker-build			:	build pneus-illico inside a docker container.
docker-build:
	@docker build -t qorpress/scorpion:latest .
.PHONY: docker-build

## docker-run			:	run pneus-illico from docker container.
docker-run:
	@docker run -ti -p 443:443 -p 9000:9000 qorpress/scorpion:latest
.PHONY: docker-run

## plugin				:	Build plugin (defined by PLUGIN variable).
plugin:
	-mkdir -p release
	echo ">>> Building: $(PLUGIN_SO) $(VERSION) for $(GOOS)-$(GOARCH) ..."
	cd plugins/$(PLUGIN) && GOOS=$(GOOS) GOARCH=$(GOARCH) go build -buildmode=plugin -o ../../release/$(PLUGIN_SO)
.PHONY: plugin

## plugins			:	Build all qorpress plugins
plugins:
	# GOARCH=amd64 PLUGIN=github.com make plugin
.PHONY: plugins  

## help				:	Print commands help.
help : Makefile
	@sed -n 's/^##//p' $<
.PHONY: help

# https://stackoverflow.com/a/6273809/1826109
%:
	@: