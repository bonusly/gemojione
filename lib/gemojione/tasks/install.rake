require 'pathname'

namespace :gemojione do
  desc "Install Emoji Image Assets"
  task :install_assets do
    target_dir = ENV['TARGET'] ||= File.join(Rails.root, 'app/assets/images/emoji')
    source_dir = File.absolute_path(File.dirname(__FILE__) + '/../../../assets')

    puts "===================================================================="
    puts "= emoji image assets install"
    puts "= Target: #{target_dir}"
    puts "= Source: #{source_dir}"
    puts "===================================================================="

    unless File.exists?(target_dir)
      puts "- Creating #{target_dir}..."
      FileUtils.mkdir_p(target_dir)
    end

    puts "- Installing assets..."
    Dir.glob("#{source_dir}/**/*") do |path|
      # Copy the assets file by file while removing the additional
      # `emoji` directory in the process
      source_path = Pathname.new(path)

      # Skip directories, they are created based on the files' dir names
      next if source_path.directory?

      relative_path = source_path.relative_path_from(Pathname.new(source_dir))
      relative_path = (relative_path.to_s.split('/') - ['emoji']).join('/')
      target_path = Pathname.new(target_dir).join(relative_path)

      # Create possible subdirectories of the target directory if they do not exist yet
      FileUtils.mkdir_p(target_path.dirname) unless target_path.dirname.exist?

      # Copy the actual file
      FileUtils.cp(source_path.to_s, target_path.to_s, verbose: false, preserve: false)
    end
  end
end
