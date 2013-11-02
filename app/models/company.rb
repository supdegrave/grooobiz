class Company < ActiveRecord::Base
    mount_uploader :logo, LogoUploader

    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories
    belongs_to :location

    @@roles = %w{principal angel investor}
    
    def allowed_roles
        @@roles
    end

    # generate accessor methods for all roles listed in @@roles 
    # example: @company.principals, @company.has_angels?
    def self.add_role_methods
        @@roles.each do |role|
            define_method(role.to_s.pluralize) { get_users_by_role(role) } 
            define_method(%Q(has_#{role}s?)) { send(role).count > 0}
        end
    end
    add_role_methods

    # there should be only one owner per company
    def owner 
        get_users_by_role( :owner ).first
    end 

    def category_list 
        categories.map{ |cat| cat.name }.join(', ')
    end

    def assign_categories=(categories)
        logger.debug 'inside assign_categories=', categories

        categories.split(',').map do |category| 
            cat = Category.find_or_create_by(name: category.strip) 
            self.categories << cat unless @company.categories.include?(cat)
        end

    end


    private 
    def get_users_by_role( role )
        User.all.find_all { |user| user.has_role? role, self }
    end
end