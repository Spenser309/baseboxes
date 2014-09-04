# Makefile for Baseboxes
.DEFAULT_GOAL := all
BOXES = ece-sl6.ks ece-sl7.ks ece-u12.seed ece-w7.unattended

define buildbox

$(1)_BASE = $(basename $(1))
$(1)_TYPE = $(suffix $(1))
$(1)_DEPS = $(wildcard definitions/$(basename $(1))/*)

ifeq ($$($(1)_TYPE),unattended)
   $$(info "hello windows")
endif

definitions/$$($(1)_BASE)/http/$(1): etc/$(1).in etc/ssh.pub
	PUBKEY=$$$$(cat etc/ssh.pub) \
	sed "s#@PUBKEY@#$$$${PUBKEY}#" etc/$(1).in > definitions/$$($(1)_BASE)/http/$(1)

$$($(1)_BASE).box: $$($(1)_DEPS) definitions/$$($(1)_BASE)/http/$(1)
	SILENT=1 bin/buildbox.sh $$($(1)_BASE)

TARGETS += $$($(1)_BASE).box
CLEAN_TARGETS += \
	$$($(1)_BASE).box \
	definitions/$$($(1)_BASE)/http/$(1)
endef

$(foreach box,$(BOXES),$(eval $(call buildbox,$(box))))

.PHONY: all

all: $(TARGETS)

clean:
	rm -rf $(CLEAN_TARGETS)
