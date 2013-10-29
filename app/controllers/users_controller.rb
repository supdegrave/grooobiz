class UsersController < ApplicationController
    before_action :set_user, only: [:show, :update, :destroy] #, :revoke_role]
    before_filter :authenticate_user!

    def index
        authorize! :index, @user, :message => 'Not authorized as an administrator.'
        @users = User.all
    end

    def show
        # @user = User.find(params[:id])
        # @user = get_user
    end

    def update
        authorize! :update, @user, :message => 'Not authorized as an administrator.'
        # @user = User.find(params[:id])
        # @user = get_user
        
        @user.avatar = params[:avatar] if params[:avatar]
        
        if @user.update_attributes(params[:user], :as => :admin)
            redirect_to users_path, :notice => "User updated."
        else
            redirect_to users_path, :alert => "Unable to update user."
        end
    end

    def destroy
        authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
        # @user = User.find(params[:id])
        # @user = get_user
        unless user == current_user
            user.destroy
            redirect_to users_path, :notice => "User deleted."
        else
            redirect_to users_path, :notice => "Can't delete yourself."
        end
    end  

    def revoke_role 
        company = Company.find(params[:company_id])
        # @user = User.find(params[:id])
        # @user = get_user
        role = params[:role]

        if user.has_role?(role, company) && user.revoke(role, company)
            params[:code] = 'success'
            params[:user_name] = user.name
        else    
            params[:code] = 'error'
            params[:error_message] = %Q(Unable to revoke role [#{role}] for #{user.name} on company #{company.name}. )
        end

        render 'revoke_role.js'
    end
    
    protected
    def set_user
        @user = User.find(params[:id])
    end 
end