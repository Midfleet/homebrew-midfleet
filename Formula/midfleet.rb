class Midfleet < Formula
  desc "Turn any AI coding assistant into a dispatchable, nudge-able agent"
  homepage "https://midfleet.io"
  url "https://registry.npmjs.org/@midfleet/agent/-/agent-0.4.11.tgz"
  version "0.4.11"
  sha256 "83f9a192c7e5f7246c9925fa098611f1abccc30dc2515f7d558f8ed2e8a9cbf0"
  license "MIT"

  depends_on "node"
  depends_on "tmux"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink "#{libexec}/bin/midfleet"
  end

  def caveats
    <<~EOS
      To get started, run:
        midfleet login --email you@example.com --workspace <workspace> --pull-runtime
        midfleet profile

      Then spawn a worker with:
        midfleet start --name my-agent --worker --team-id <team-id>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/midfleet --version")
    assert_match "Usage: midfleet", shell_output("#{bin}/midfleet --help")
    assert_match "Sign in to Midfleet", shell_output("#{bin}/midfleet login --help")
    assert_match "Show the signed-in Midfleet user profile", shell_output("#{bin}/midfleet profile --help")
  end
end
