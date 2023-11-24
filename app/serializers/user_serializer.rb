class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name, :role, :avatar, :created_at
end
