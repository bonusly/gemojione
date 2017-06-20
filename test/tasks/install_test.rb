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

  let(:task) { Rake::Task['gemojione:install_assets'] }
  let(:target_directory) { Rails.root.join('app/assets/images') }
  let(:source_directory) { Rails.root.join('..', 'vendor/assets/images') }

  it 'accepts a custom target directory through ENV' do
    custom_target_directory = Rails.root.join('some', 'custom', 'directory')
    ENV['TARGET']           = custom_target_directory.to_s
    task.invoke
    assert custom_target_directory.exist?
    ENV['TARGET'] = nil
  end

  it "creates the target directory if it doesn't exist" do
    assert !target_directory.exist?
    task.invoke
    assert target_directory.exist?
  end

  it 'copies all files from source to target' do
    task.invoke
    Dir.glob(source_directory.join('**', '*')) do |path|
      source_path = Pathname.new(path)
      target_path = target_directory.join(source_path.relative_path_from(source_directory))
      assert target_path.exist?, "The target file #{target_path} does not exist."
    end
  end
end