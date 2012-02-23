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
      
      class << self
      
      def auth_subject
        @auth_subject ||= if auth_subject_type && auth_subject_value
          auth_object_type.constantize.find(:conditions => {auth_subject_field => auth_subject_value})
        end
      end

    end
  end
end
