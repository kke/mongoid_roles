module Mongoid
  module Roles
    @@subjects = []
    @@objects = []
    def self.subjects
      @@subjects.uniq!
    end
    def self.objects
      @@objects.uniq!
    end
  end
end
