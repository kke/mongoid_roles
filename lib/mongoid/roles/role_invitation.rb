module Mongoid
  module Roles
    class RoleInvitation
      include Mongoid::Document
      include Mongoid::Timestamps

      embedded_in   :auth_object

      field :role,                     :type => Symbol
      field :auth_subject_type,        :type => String
      field :auth_subject_field,       :type => String
      field :auth_subject_value,       :type => String
      
    end
  end
end
