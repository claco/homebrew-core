class Twoping < Formula
  desc "Ping utility to determine directional packet loss"
  homepage "https://www.finnie.org/software/2ping/"
  url "https://www.finnie.org/software/2ping/2ping-4.1.tar.gz"
  sha256 "85331ae57f445bc8895ba4e61da4c7300b67fde55642f5e42ea02f2daf07b1ed"
  head "https://github.com/rfinnie/2ping.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d6d55717d2d8a88de05fe7ca002f2d0767948b8bc09bc9817124969b1a7e4636" => :high_sierra
    sha256 "104e2f8bebcfd2ab3504d80170733a91eefd8c64fe70d1ba6086c48f1757926b" => :sierra
    sha256 "104e2f8bebcfd2ab3504d80170733a91eefd8c64fe70d1ba6086c48f1757926b" => :el_capitan
    sha256 "104e2f8bebcfd2ab3504d80170733a91eefd8c64fe70d1ba6086c48f1757926b" => :yosemite
  end

  depends_on :python3

  def install
    pyver = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{pyver}/site-packages"
    system "python3", *Language::Python.setup_install_args(libexec)
    man1.install "doc/2ping.1"
    man1.install_symlink "2ping.1" => "2ping6.1"
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  plist_options :manual => "2ping --listen", :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/2ping</string>
          <string>--listen</string>
          <string>--quiet</string>
        </array>
        <key>UserName</key>
        <string>nobody</string>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    system bin/"2ping", "-c", "5", "test.2ping.net"
  end
end
