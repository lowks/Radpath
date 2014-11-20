set -x
set -e

export PATH=`pwd`/otp_src_17.0/bin:$PATH
export STABLE_ELIXIR_VERSION="1.0.2"

if [ ! -e elixir/bin/elixir ]; then
   wget --no-clobber -q https://github.com/elixir-lang/elixir/archive/v${STABLE_ELIXIR_VERSION}.zip && unzip -qq precompiled.zip -d elixir
fi
