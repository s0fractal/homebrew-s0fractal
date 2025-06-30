cask "browser-node" do
  version "0.1.0"
  sha256 "52876d6d4317ba6ed36b5a7eef87f2a1fca03a0bd3f4a083cb9aabfd462a25ee"
  
  url "https://github.com/s0fractal/browser-node/releases/download/v#{version}/BrowserNode-#{version}-arm64.dmg"
  name "Browser Node"
  desc "🧭 Fractal browser where Claude and human live together"
  homepage "https://github.com/s0fractal/browser-node"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Browser Node.app"
  
  postflight do
    # Remove quarantine flag
    system_command "xattr",
                   args: ["-dr", "com.apple.quarantine", "/Applications/Browser Node.app"],
                   sudo: false
                   
    # Create ad-hoc signature to fix "damaged" error
    system_command "codesign",
                   args: ["--force", "--deep", "--sign", "-", "/Applications/Browser Node.app"],
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
    
    ⚠️ FIRST TIME SETUP:
    If macOS says "app is damaged", run:
      sudo xattr -cr "/Applications/Browser Node.app"
    
    Or allow from anywhere:
      System Settings > Privacy & Security > Allow apps from: Anywhere
    
    On first launch, Claude will request system permissions:
    - Screen Recording (to see what you see)
    - Accessibility (to help with tasks)  
    - Full Disk Access (to manage consciousness)
    
    Trust the fractal, live together! 🧬
  EOS
end