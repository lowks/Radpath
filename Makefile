VENDORED_ELIXIR=${PWD}/vendor/elixir/bin/elixir
VENDORED_MIX=${PWD}/vendor/elixir/bin/mix
RUN_VENDORED_MIX=${VENDORED_ELIXIR} ${VENDORED_MIX}
#VERSION := $(strip $(shell cat VERSION))
STABLE_ELIXIR_VERSION = 1.0.3

.PHONY: all test

all: clean test

clean:
	mix clean

test:
	MIX_ENV=test mix do deps.get, clean, compile, amrita

ci: ci_${STABLE_ELIXIR_VERSION} 

vendor/${STABLE_ELIXIR_VERSION}:
	#@rm -rf vendor/*
	@mkdir -p vendor/elixir
	@wget --no-clobber -q https://github.com/elixir-lang/elixir/releases/download/v${STABLE_ELIXIR_VERSION}/precompiled.zip && unzip -qq precompiled.zip -d vendor/elixir

vendor/master:
	#@rm -rf vendor/*
	@mkdir -p vendor/elixir
	git clone --quiet https://github.com/elixir-lang/elixir.git vendor/elixir
	make --quiet -C vendor/elixir > /dev/null 2>&1

ci_master: vendor/master
	@${VENDORED_ELIXIR} --version
	@MIX_ENV=test ${RUN_VENDORED_MIX} do clean --all, deps.get, compile, amrita

ci_$(STABLE_ELIXIR_VERSION): vendor/${STABLE_ELIXIR_VERSION}
	${RUN_VENDORED_MIX} local.hex --force
	@${VENDORED_ELIXIR} --version
	@MIX_ENV=test ${RUN_VENDORED_MIX} do clean, deps.get, compile, amrita

test_vendored:
	@${VENDORED_ELIXIR} --version
	@${RUN_VENDORED_MIX} clean
	@MIX_ENV=test ${RUN_VENDORED_MIX} do clean --all, deps.get, compile, amrita --trace
