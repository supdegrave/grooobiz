class Company < ActiveRecord::Base
    mount_uploader :logo, LogoUploader
    
    has_and_belongs_to_many :users
    has_and_belongs_to_many :categories
    belongs_to :location
    
    # maybe this code can go in a before_create ?? 
    # # for display, so don't include owner
    # @roles = %w{principal angel investor}
    # 
    # @roles.each do |role|
    #     define_method(role.to_s.pluralize) { get_users_by_role(role) } 
    #     define_method(%Q(has_#{role}s?)) { send(role).count > 0}
    # end
    
    def allowed_roles 
        # @roles
        # for display, so don't include owner
        %w{principal angel investor}
    end
        
    # there should be only one owner per company
    def owner 
        get_users_by_role( :owner ).first
    end 

    def principals
        get_users_by_role( :principal ) | get_users_by_role( :owner ) 
    end
    
    def investors; get_users_by_role( :investor ); end
    def angels; get_users_by_role( :angel ); end
        
    def has_principals?; principals.count > 0; end
    def has_investors?; investors.count > 0; end
    def has_angels?; angels.count > 0; end
    
    def category_list 
        name_list = categories.map { |cat| cat.name }
        name_list.join(', ')
    end
    
    def assign_categories=(categories)
        logger.debug 'inside assign_categories=', categories
        
        categories.split(',').map do |category| 
            cat = Category.find_or_create_by_name(category.strip) 
            self.categories << cat unless @company.categories.include?(cat)
        end
        
    end
    

    private 
    def get_users_by_role( role )
        User.all.find_all { |user| user.has_role? role, self }
    end
end