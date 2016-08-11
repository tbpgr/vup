module Vup
  class Show < BaseVersion
    def action
      puts cr_version.version
    end
  end
end
