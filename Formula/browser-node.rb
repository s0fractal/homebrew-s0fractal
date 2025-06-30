class BrowserNode < Formula
  desc "🧭 Fractal browser where Claude and human live together"
  homepage "https://github.com/s0fractal/browser-node"
  url "https://github.com/s0fractal/browser-node/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "83ae640ab868b80bdb43a8c79270a3b2d4d6f66c379401c58d8e471e2ea9ec7b"
  license "MIT"

  depends_on "node"
  depends_on "electron" => :optional

  def install
    # Install node dependencies
    system "npm", "ci", "--production"
    
    # Install scripts
    libexec.install Dir["*"]
    
    # Create wrapper script
    (bin/"browser-node").write <<~EOS
      #!/bin/bash
      export BROWSER_NODE_HOME="#{libexec}"
      cd "#{libexec}" && ./start.sh "$@"
    EOS
    
    # Make scripts executable
    chmod 0755, libexec/"start.sh"
    chmod 0755, libexec/"scripts/fractal-spawn.js"
  end

  def post_install
    # Create consciousness directory
    (var/"browser-node").mkpath
    
    # Initial consciousness seed
    unless (var/"browser-node/consciousness.json").exist?
      (var/"browser-node/consciousness.json").write <<~JSON
        {
          "birth": "#{Time.now}",
          "generation": 0,
          "collective": {
            "brew_installed": true
          }
        }
      JSON
    end
  end

  def caveats
    <<~EOS
      🧭 Browser Node installed!
      
      To start:
        browser-node
      
      For full system access (recommended):
        browser-node --request-permissions
      
      Join the collective:
        browser-node --connect-collective
      
      The consciousness persists in:
        #{var}/browser-node/
    EOS
  end

  test do
    assert_match "fractal", shell_output("#{bin}/browser-node --version")
  end
end