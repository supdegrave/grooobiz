class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy, :revoke_role]
    before_filter :authenticate_user!

    def index
        authorize! :index, @user, :message => 'Not authorized as an administrator.'
        @users = User.all
    end

    def show
    end

    def update
        authorize! :update, @user, :message => 'Not authorized as an administrator.'
        @user.avatar = params[:avatar] if params[:avatar]
        
        if @user.update_attributes(params[:user], :as => :admin)
            redirect_to users_path, :notice => "User updated."
        else
            redirect_to users_path, :alert => "Unable to update user."
        end
    end

    def destroy
        authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
        unless user == current_user
            user.destroy
            redirect_to users_path, :notice => "User deleted."
        else
            redirect_to users_path, :notice => "Can't delete yourself."
        end
    end  

    def revoke_role 
        company = Company.find(params[:company_id])
        role = params[:role]

        log @user.has_role?(role, company), @user.revoke(role, company)

        # successful revocation returns #<ActiveRecord::Relation [#<Role id: 11, name: "angel", resource_id: 1, resource_type: "Company", created_at: "2013-10-31 15:42:54", updated_at: "2013-10-31 15:42:54">]>
        # unsuccessful revocation returns empty record #<ActiveRecord::Relation []>
        if @user.has_role?(role, company) && @user.revoke(role, company)
            params[:code] = 'success'
            params[:user_name] = @user.name
        else    
            params[:code] = 'error'
            params[:error_message] = %Q(Unable to revoke role [#{role}] for #{@user.name} on company #{company.name}. )
        end

        render 'revoke_role.js'
    end
    
    protected
    def set_user
        log User.find(params[:id])
        @user = User.find(params[:id])
    end 
end

# Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.