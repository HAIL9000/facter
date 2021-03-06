test_name "log-level setting can be used to specific logging level"
#
# This tests ensures that the cli.log-level config file setting works
# properly. The value of the setting should be a string indicating the
# logging level.
#
config = <<EOM
cli : {
    log-level : debug
}
EOM

agents.each do |agent|
  step "Agent #{agent}: create config file"
  config_dir = agent.tmpdir("config_dir")
  config_file = File.join(config_dir, "facter.conf")
  create_remote_file(agent, config_file, config)

  step "log-level set to debug should print DEBUG output to stderr"
  on(agent, facter("--config '#{config_file}'")) do
    assert_match(/DEBUG/, stderr, "Expected DEBUG information in stderr")
  end
end
