json.array!(@tops) do |top|
  json.extract! top, :id, :name
  json.url top_url(top, format: :json)
end
