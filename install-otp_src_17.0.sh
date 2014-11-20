set -x
set -e
if [ ! -e otp_src_17.0/bin/erl ]; then
  curl -O http://www.erlang.org/download/otp_src_17.0.tar.gz
  tar xzf otp_src_17.0.tar.gz
  cd otp_src_17.0
  ./configure --enable-smp-support \
              --enable-m64-build \
              --disable-native-libs \
              --disable-sctp \
              --enable-threads \
              --enable-kernel-poll \
              --disable-hipe \
              --without-javac
  make;
fi
