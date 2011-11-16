set :rails_env, "staging"
set :deploy_to, "#{deploy_root}/rubyrep-#{rails_env}"
set :rvm_gemset, "#{application}-#{rails_env}"
set :rvm_ruby_string, "#{ruby_version}@#{rvm_gemset}"
set :gem_path, "#{deploy_root}/.rvm/gems/ruby-#{ruby_version}-p#{ruby_patch}@#{rvm_gemset}"
set :default_environment, {
  'PATH' => "#{gem_path}/bin:#{deploy_root}/.rvm/bin:#{deploy_root}/.rvm/ruby-#{ruby_version}-p#{ruby_patch}/bin:$PATH",
  'RUBY_VERSION' => "ruby #{ruby_version}",
  'GEM_HOME'     => gem_path,
  'GEM_PATH'     => gem_path,
  'BUNDLE_PATH'  => gem_path,
  'LC_ALL'       => 'en_US.UTF-8',
  'LANG'         => 'en_US.UTF-8'
}
set :current_path, "#{deploy_to}/current"
set :shared_path, "#{deploy_to}/shared"
