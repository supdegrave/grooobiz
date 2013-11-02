class CompaniesController < ApplicationController
    before_action :set_company, only: [:show, :edit, :update, :destroy]
    before_filter :authenticate_user!, except: :home

    # GET /companies
    # GET /companies.json
    def index
        @companies = Company.all
    end

    # GET /companies/1
    # GET /companies/1.json
    def show
    end

    # GET /companies/new
    def new
        @company = Company.new

        @company.categories = []
        @company.location = Location.new
        @company.logo = params[:logo] if params[:logo]
    end

    # GET /companies/1/edit
    def edit
    end

    # POST /companies
    # POST /companies.json
    def create
        categories = process_categories
        location = process_location
        @company = Company.new(company_params)
        @company.categories = categories
        @company.location = location
        
        @company.logo = params[:logo] if params[:logo]

        respond_to do |format|
            if @company.save
                # person who created the company is assigned :owner and :principal roles by default 
                current_user.add_role :owner, @company
                current_user.add_role :principal, @company

                format.html { redirect_to @company, notice: 'Company was successfully created.' }
                format.json { render action: 'show', status: :created, location: @company }
            else
                format.html { render action: 'new' }
                format.json { render json: @company.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /companies/1
    # PATCH/PUT /companies/1.json
    def update
        @company.logo = params[:logo] if params[:logo]
        
        if company_params.has_key?('add_role')
            user = User.find(company_params['id'])
            user.add_role( company_params['add_role'], @company ) if user
            
            redirect_to edit_company_path # , notice: user.name + ' added to company as ' + company_params['add_role'].to_s.capitalize
        else
            respond_to do |format|
                @company.categories = process_categories
                @company.location = process_location if 'true' == params[:location][:dirty]
                
                if @company.update(company_params)
                    format.html { redirect_to @company, notice: 'Company was successfully updated.' }
                    format.json { head :no_content }
                else
                    format.html { render action: 'edit' }
                    format.json { render json: @company.errors, status: :unprocessable_entity }
                end
            end
        end
    end

    # DELETE /companies/1
    # DELETE /companies/1.json
    def destroy
    
        @company.destroy
        respond_to do |format|
            format.html { redirect_to companies_url }
            format.json { head :no_content }
        end
    end

    
    protected
    def process_location
        Location.find_or_create_by(name: params[:location][:name])
    end
    
    def process_categories
        params[:company].delete(:category_list)
            .split(',')
            .map { |category| Category.find_or_create_by(name: category.strip) }
    end
    

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_company
        @company = Company.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def company_params
        params.
            require(:company).
            permit( :user_id, 
                    :name, 
                    :description, 
                    :tagline, 
                    :audience, 
                    :launch_date, 
                    :add_role, 
                    :id, 
                    :location,
                    :category_list,
                    :logo )
    end
end