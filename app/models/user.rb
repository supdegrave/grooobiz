class User < ActiveRecord::Base
    mount_uploader :avatar, AvatarUploader
    
	has_and_belongs_to_many :companies
	rolify
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise	:database_authenticatable, 
	        :registerable,
			:recoverable,
			:rememberable, 
			:trackable, 
			:validatable
	
	def name 
		"#{firstname} #{lastname}"
	end
	
	def is_admin?
	    has_role? :admin
    end
    
    def is_principal?(company)
        has_role?(:principal, company) || has_role?(:owner, company) 
    end
    
    def can_edit?(company)
        is_principal?(company) || is_admin? 
    end
    
    def companies_by_role(role)
        Company.all.find_all { |c| has_role?(role, c) }
    end
end
