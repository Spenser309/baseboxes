# Makefile for Baseboxes
.DEFAULT_GOAL := all
BOXES = ece-sl6.ks ece-u12.seed
TARGETS = .bundler

define buildbox

$(1)_BASE = $(basename $(1))
$(1)_TYPE = $(suffix $(1))
$(1)_DEPS = $(wildcard definitions/$(basename $(1))/*)

definitions/$$($(1)_BASE)/$(1): etc/$(1).in etc/ssh.pub
	PUBKEY=$$$$(cat etc/ssh.pub); sed "s#@PUBKEY@#$$$${PUBKEY}#" etc/$(1).in > definitions/$$($(1)_BASE)/$(1)

$$($(1)_BASE).box: $$($(1)_DEPS) definitions/$$($(1)_BASE)/$(1)
	bin/buildbox.sh $$($(1)_BASE)

TARGETS += $$($(1)_BASE).box
CLEAN_TARGETS += \
	$$($(1)_BASE).box \
	definitions/$$($(1)_BASE)/$(1)
endef

.bundler:
	# Work around for bug in eventmachine (related to winrm)
	bundle config --local build.eventmachine -- --with-cflags=\"-O2 -pipe -march=native -w\"
	bundle install --path=.bundler

$(foreach box,$(BOXES),$(eval $(call buildbox,$(box))))

.PHONY: all

all: $(TARGETS)

clean:
	rm -rf $(CLEAN_TARGETS)
