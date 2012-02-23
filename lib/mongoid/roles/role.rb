module Mongoid
  module Roles
    class Role
      include Mongoid::Document
      include Mongoid::Timestamps

      embedded_in   :auth_subject

      field :role,              :type => Symbol
      field :auth_object_type,  :type => String
      field :auth_object_id,    :type => String

      scope :find_object, lambda  {|object| where(:auth_object_type => object.class.name, :auth_object_id => object.id)}
      scope :find_role, lambda { |role, object=nil|
        object ?  where(:role => role, :auth_object_type => object.class.name, :auth_object_id => object.id) :
                  where(:role => role, :auth_object_type => nil, :auth_object_id => nil)
      }
      scope :find_objects_by_type, lambda {|object_type| where(:auth_object_type => object_type)}
      scope :find_objects_by_roles, lambda {|*roles| 
        where(:role => {'$in' => roles.flatten})
      }
      
      class << self
      
        # subject.has_role?(role, object = nil). Returns true of false (has or has not).
        def has_role? (role, object = nil)
          find_role(role,object).count == 1
        end
       
        # subject.has_role!(role, object = nil). Assigns a role for the object to the subject. 
        # Does nothing is subject already has such a role.
        # IMPELEMENTED IN MongoidRoles::Subject
      
        # subject.has_no_role!(role, object = nil). Unassigns a role from the subject.
        def has_no_role! (role, object = nil)
          find_role(role,object).destroy_all
        end
      
        # subject.has_roles_for?(object). Does the subject has any roles for object? (true of false)
        def has_roles_for? (object)
          find_object(object).count > 0
        end
      
        # subject.has_role_for?(object). Same as has_roles_for?.
        def has_role_for? (object)
          has_roles_for?(object)
        end
       
        # subject.roles_for(object). Returns an array of Role instances, corresponding to subject ’s roles on
        # object. E.g. subject.roles_for(object).map(&:role).sort will give you role names in alphabetical order.
        # If called with a string, will return roles for all objects of that type. E.g. subject.roles_for('Group').
        def roles_for (object)
          if object.kind_of?(String) || object.kind_of?(Symbol)
            find_objects_by_type(object.to_s.singularize.camelcase)
          else
            find_object(object)
          end
        end

        # subject.with_role(roles). Returns an array of Role instances, corresponding to subject ’s roles on
        # object where the role name matches the given argument. Argument can also be a list of roles.. E.g. 
        # subject.with_role(:admin, :member).map(&:role).sort will give you all 'admin' and 'member' roles.
        def with_role (*roles)
          find_objects_by_roles(roles)
        end

        # subject.has_no_roles_for!(object). Unassign any subject ’s roles for a given object.
        def has_no_roles_for! (object)
          find_object(object).destroy_all
        end
      
        # subject.has_no_roles!. Unassign all roles from subject.
        def has_no_roles!
          criteria.destroy_all
        end
        
        # def find_role(role, object = nil)
        #   object ? find_role_with_object(role,object) : find_role(role)
        # end
      end
  
      def auth_object
        @auth_object ||= if auth_object_type && auth_object_id
          auth_object_type.constantize.find(auth_object_id)
        end
      end

      def auth_object=(auth_object)
        return unless auth_object
        
        self.auth_object_type = auth_object.class.name
        self.auth_object_id   = auth_object.id
      end
    end
  end
end
