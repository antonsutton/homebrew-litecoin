require 'formula'

class Litecoind < Formula
  homepage 'http://litecoin.org/'
  head 'https://github.com/litecoin-project/litecoin.git'
  url 'https://github.com/litecoin-project/litecoin.git', :tag => 'v0.8.5'
  version '0.8.5'

  head do
    url 'https://github.com/litecoin-project/litecoin.git', :branch => 'master-0.8'
    version 'master'

    depends_on 'automake'
    depends_on 'pkg-config'
    depends_on 'protobuf'
  end

  depends_on 'berkeley-db4'
  depends_on 'boost'
  depends_on 'miniupnpc' if build.include? 'with-upnp'
  depends_on 'openssl'

  option 'with-upnp', 'Compile with UPnP support'
  option 'without-ipv6', 'Compile without IPv6 support'

  def patches
    'contrib/homebrew/makefile.osx.patch'
  end

  def install
    raise 'Litecoind currently requires --HEAD on Mavericks' if MacOS.version == :mavericks and not build.head?

    cd "src" do
      system "make", "-f", "makefile.osx",
        "DEPSDIR=#{HOMEBREW_PREFIX}",
        "USE_UPNP=#{(build.include? 'with-upnp') ? '1' : '-'}",
        "USE_IPV6=#{(build.include? 'without-ipv6') ? '-' : '1'}"
    end

    system "strip src/litecoind"
    bin.install "src/litecoind"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_prefix}/bin/litecoind</string>
          <string>-daemon</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    You will need to setup your litecoin.conf if you haven't already done so:

    echo -e "rpcuser=bitcoinrpc\\nrpcpassword=$(xxd -l 16 -p /dev/urandom)" > ~/Library/Application\\ Support/Litecoin/litecoin.conf
    chmod 600 ~/Library/Application\\ Support/Litecoin/litecoin.conf

    Use `litecoind stop` to stop litecoind if necessary! `brew services stop litecoind` does not work!
    EOS
  end
end

