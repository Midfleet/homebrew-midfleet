require "json"

class Midfleet < Formula
  desc "Turn any AI coding assistant into a dispatchable, nudge-able agent"
  homepage "https://midfleet.io"
  url "https://registry.npmjs.org/@midfleet/agent/-/agent-0.4.45.tgz"
  version "0.4.45"
  sha256 "6503870e279558db6ab83f9ffd653a23aaec3351476938a6e92a62085b60986f"
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
        midfleet start --name my-agent --worker --project <project-code> --team-id <team-id>
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/midfleet --version")
    assert_match "Usage: midfleet", shell_output("#{bin}/midfleet --help")
    assert_match "Sign in to Midfleet", shell_output("#{bin}/midfleet login --help")
    assert_match "Show the signed-in Midfleet user profile", shell_output("#{bin}/midfleet profile --help")
    assert_match "Usage: midfleet workspace", shell_output("#{bin}/midfleet workspace --help")
    assert_match "Start Epic refinement", shell_output("#{bin}/midfleet epic refinement --help")

    version_json = shell_output("#{bin}/midfleet version --json")
    version_data = JSON.parse(version_json)
    assert_equal version.to_s, version_data["version"]
    assert_equal "midfleet", version_data["cli"]

    update_json = shell_output("#{bin}/midfleet update-check --json")
    update_data = JSON.parse(update_json)
    assert update_data["installed"].is_a?(String)
    assert(update_data["installed"].match(/^\d+\.\d+\.\d+/))
    assert [true, false].include?(update_data["upToDate"])
    assert update_data["installCommand"].is_a?(String)
  end
end