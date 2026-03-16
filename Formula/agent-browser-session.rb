class AgentBrowserSession < Formula
  desc "Headless browser automation CLI for AI agents"
  homepage "https://github.com/BUNotesAI/agent-browser-session"
  version "0.4.5"

  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.5/agent-browser-session-darwin-arm64.tar.gz"
      sha256 "003d54163e24c2bea3844c64ae050991b81f9280091224bc77e6257521a5c6ff"
    elsif Hardware::CPU.intel?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.5/agent-browser-session-darwin-x64.tar.gz"
      sha256 "ed6f5334be38b455cff05d7baf80c67c5b4d770202641441fa3c74df8bc6180a"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.5/agent-browser-session-linux-arm64.tar.gz"
      sha256 "8faa83c864fe5d3a702f7a6d1bd734b7f2f5423b90a6de711692049f08c40d7d"
    elsif Hardware::CPU.intel?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.5/agent-browser-session-linux-x64.tar.gz"
      sha256 "e0437248c60247ebed354cf82c52857583f44ac20d6e161efca3170b690323fd"
    end
  end

  def install
    libexec.install "dist"
    libexec.install "node_modules"
    libexec.install "package.json"
    libexec.install "bin/agent-browser-session"

    # Wrapper script sets AGENT_BROWSER_DAEMON_DIR so the binary finds daemon.js
    (bin/"agent-browser-session").write <<~SH
      #!/bin/sh
      export AGENT_BROWSER_DAEMON_DIR="#{libexec}/dist"
      exec "#{libexec}/agent-browser-session" "$@"
    SH
    chmod 0755, bin/"agent-browser-session"
  end

  def post_install
    system "npx", "--prefix", libexec.to_s, "patchright", "install", "chromium"
  end

  test do
    assert_match "agent-browser-session", shell_output("#{bin}/agent-browser-session --help")
  end
end
