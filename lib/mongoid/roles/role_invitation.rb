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
    
      def auth_object
        eval(metadata.inverse_class_name).first(:conditions => {'role_invitations._id' => _id})
      end
    end
  end
end
