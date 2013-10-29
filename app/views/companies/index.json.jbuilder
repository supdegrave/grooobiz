json.array!(@companies) do |company|
  json.extract! company, :user_id, :name, :description
  json.url company_url(company, format: :json)
end
