# encoding: UTF-8

require File.expand_path(File.join(File.dirname(__FILE__), '..', 'test_helper'))
require 'pathname'
require 'rake'

class Rails
  def self.root
    Pathname.new File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'tmp'))
  end
end

describe 'gemojione:install_assets' do
  before do
    load File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib', 'gemojione', 'tasks', 'install.rake'))
  end

  after do
    Rake::Task.clear
    FileUtils.rm_rf Rails.root
  end

  def subject
    Rake::Task['gemojione:install_assets']
  end

  def target_directory
    Rails.root.join('app/assets/images/emoji')
  end

  def source_directory
    Rails.root.join('..', 'assets')
  end

  it 'accepts a custom target directory through ENV' do
    custom_target_directory = Rails.root.join('some', 'custom', 'directory')
    ENV['TARGET']           = custom_target_directory.to_s
    subject.invoke
    assert custom_target_directory.exist?
    ENV['TARGET'] = nil
  end

  describe 'default configuration' do
    before do
      subject.invoke
    end

    it "creates the target directory if it doesn't exist" do
      assert target_directory.exist?
    end

    it 'copies all files from source to target, removing the additional `emoji` directory' do
      Dir.glob(source_directory.join('**', '*')) do |path|
        source_path = Pathname.new(path)
        relative_path = source_path.relative_path_from(source_directory)
        relative_path = (relative_path.to_s.split('/') - ['emoji']).join('/')
        target_path = target_directory.join(relative_path)

        assert !relative_path.to_s.include?('emoji/')
        assert target_path.exist?
      end
    end
  end
end
