require "formula"

class Tvheadend < Formula
  homepage "http://www.tvheadend.org"
  head 'git://github.com/tvheadend/tvheadend.git'
  
  depends_on 'pkg-config' => :build
  depends_on 'uriparser'
  
  def install
    args = ["--prefix=#{prefix}"]
    system "./configure", *args
    system "make install"
  end
  
  def post_install
    unless File.exist? "#{var}/tvheadend"
      mkdir_p "#{var}/tvheadend/accesscontrol"
      (var/'tvheadend/accesscontrol/1').write <<-EOS.undent
      {
        "enabled": 1,
        "username": "*",
        "password": "*",
        "comment": "Default access entry",
        "prefix": "0.0.0.0/0,::/0",
        "streaming": 1,
        "dvr": 1,
        "dvrallcfg": 1,
        "webui": 1,
        "admin": 1,
        "tag_only": 0,
        "id": "1"
      }
      EOS
    end
  end

  plist_options :startup => true

  def plist
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
      <key>Label</key><string>#{plist_name}</string>
      <key>ProgramArguments</key>
        <array>
          <string>#{bin}/tvheadend</string>
          <string>-c</string>
          <string>#{var}/tvheadend</string>
        </array>
      <key>Disabled</key><false/>
      <key>KeepAlive</key><true/>
      <key>RunAtLoad</key><true/>
    </dict>
    </plist>
    EOS
  end
end
