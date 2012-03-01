module Mongoid
  module Roles
    module Object
      extend ActiveSupport::Concern

      included do
        embeds_many :role_invitations, :class_name => 'Mongoid::Roles::RoleInvitation'
        Mongoid::Roles.objects << self.name
      end

      #  object.accepts_role?(role_name, subject). An alias for subject.has_role?(role_name, object).
      def accepts_role?(role_name, subject)
        subject.has_role?(role_name, self)
      end

      #  object.accepts_role!(role_name, subject). An alias for subject.has_role!(role_name, object).
      def accepts_role!(role_name, subject)
        subject.has_role!(role_name, self)
      end

      #  object.accepts_no_role!(role_name, subject). An alias for subject.has_no_role!(role_name, object).
      def accepts_no_role!(role_name, subject)
        subject.has_no_role!(role_name, self)
      end

      #  object.accepts_roles_by?(subject). An alias for subject.has_roles_for?(object).
      def accepts_roles_by?(subject)
        subject.has_roles_for?(self)
      end

      #  object.accepts_role_by?(subject). Same as accepts_roles_by?.
      def accepts_role_by?(subject)
        accepts_roles_by?(subject)
      end

      #  object.accepts_roles_by(subject). An alias for subject.roles_for(object).
      def accepts_roles_by(subject)
        subject.roles_for(self)
      end

      def has_role_invitation! (role, auth_subject_type, auth_subject_field, auth_subject_value)
        role_invitations.find_or_create_by(
          :role => role, 
          :auth_subject_type => auth_subject_type, 
          :auth_subject_field => auth_subject_field,
          :auth_subject_value => auth_subject_value
        )
      end   

      def role_invitations_for(object, field)
        role_invitations.where(
          :auth_subject_type => object.class.to_s,
          :auth_subject_field => field.to_s,
          :auth_subject_value => object[field]
        )
      end

      def role_subjects
        subjects = []
        Mongoid::Roles.subjects.each do |subject_type|
          eval(subject_type).where('roles.auth_object_type' => self.class.to_s, 'roles.auth_object_id' => self._id.to_s).each do |o| 
            subjects << o
          end
        end
        subjects
      end

    end
  end
end
