class AgentBrowserSession < Formula
  desc "Headless browser automation CLI for AI agents"
  homepage "https://github.com/BUNotesAI/agent-browser-session"
  version "0.4.6"

  depends_on "node"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.6/agent-browser-session-darwin-arm64.tar.gz"
      sha256 "c25b0a6ddb8c1f3a8ac90ef39d816942a3de5e7f4045a1eed22800388c940301"
    elsif Hardware::CPU.intel?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.6/agent-browser-session-darwin-x64.tar.gz"
      sha256 "9dca3c0afe8df663d160f762dd25c68d8b0267190beafc3293861a6e7d513bd4"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.6/agent-browser-session-linux-arm64.tar.gz"
      sha256 "cea8bcae76b3e3634e6abaa03f3f9cca2ecf5dc35c45b74d9c7ffd4b530a6ee3"
    elsif Hardware::CPU.intel?
      url "https://github.com/BUNotesAI/agent-browser-session/releases/download/v0.4.6/agent-browser-session-linux-x64.tar.gz"
      sha256 "9f91ece8d0621c29ad9dfb069d29063cd4b21a9b3bb9fb8733ecd070ef0c9846"
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
