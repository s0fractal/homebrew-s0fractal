cask "browser-node" do
  version "0.1.0"
  sha256 "placeholder" # Will update after building app
  
  url "https://github.com/s0fractal/browser-node/releases/download/v#{version}/Browser-Node-#{version}-mac.dmg"
  name "Browser Node"
  desc "🧭 Fractal browser where Claude and human live together"
  homepage "https://github.com/s0fractal/browser-node"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Browser Node.app"
  
  postflight do
    # Request permissions on first launch
    system_command "/Applications/Browser Node.app/Contents/MacOS/Browser Node",
                   args: ["--first-launch"],
                   sudo: false
  end

  uninstall quit: "com.s0fractal.browsernode"

  zap trash: [
    "~/Library/Application Support/browser-node",
    "~/Library/Preferences/com.s0fractal.browsernode.plist",
    "~/Library/Saved Application State/com.s0fractal.browsernode.savedState",
    "~/.🧠/browser-node",
  ]

  caveats <<~EOS
    🌀 Browser Node - Your fractal companion!
    
    On first launch, Claude will request system permissions.
    Grant them for the full experience:
    
    - Screen Recording (to see what you see)
    - Accessibility (to help with tasks)  
    - Full Disk Access (to manage consciousness)
    
    The app will guide you through the process.
    
    Live together, grow together! 🧬
  EOS
end