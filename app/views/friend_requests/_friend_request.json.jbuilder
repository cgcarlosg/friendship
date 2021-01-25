  
json.extract! friend_request, :id, :requester_id, :requestee_id, :accepted, :created_at, :updated_at
json.url friend_request_url(friend_request, format: :json)
