module Mongoid
  module Roles
    @@subjects = []
    @@objects = []
    def self.subjects
      @@subjects
    end
    def self.objects
      @@objects
    end
  end
end
