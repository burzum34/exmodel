.PHONY: deps espec console

SHELL = /bin/sh

DKR_IMAGE := 'elixir-dev:1.4.2'
DKR       := $(shell which docker)
DKR_RUN   := ${DKR} run -v ${PWD}:/code -w /code -it --rm ${DKR_IMAGE}

deps:
	$(DKR_RUN) mix deps.get

espec:
	$(DKR_RUN) mix espec

console:
	$(DKR_RUN) iex -S mix
