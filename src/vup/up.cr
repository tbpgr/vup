require "yaml"

module Vup
  class Up < BaseVersion
    getter! new_version : ProjectVersion

    def action
      if @dry_run
        puts new_version.version
      else
        bumpup_files
        output_new_version
      end
    end

    def new_version
      @new_version ||= cr_version.dup.bumpup(version)
    end

    private def bumpup_files
      update_files
    end

    private def update_files
      update_version_cr(new_version)
      update_shard_yml(new_version)
    end

    private def update_version_cr(new_version)
      src = File.read(version_cr_path)
      new_src = src.gsub(/\d+.\d+\.\d+/, new_version.version)
      File.write(version_cr_path, new_src)
    end

    private def update_shard_yml(new_version)
      src = File.read(SHARD_PATH)
      new_src = src.gsub(/version: \d+.\d+\.\d+/, "version: #{new_version.version}")
      File.write(SHARD_PATH, new_src)
    end

    private def output_new_version
      STDOUT.puts(new_version.version)
    end
  end
end
