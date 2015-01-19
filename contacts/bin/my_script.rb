require 'addressable/uri'
require 'rest-client'

def create_user
  url = Addressable::URI.new(
  scheme: 'http',
  host: 'localhost',
  port: 3000,
  path: '/users.json'
  ).to_s

  puts RestClient.post(
  url,
  { user: { name: "Gizmo", email: "gizmo@gizmo.gizmo" } }
  )
end

# url = Addressable::URI.new(
#   scheme: 'http',
#   host: 'localhost',
#   port: 3000,
#   path: '/users.html',
#   query_values: {var1: :val1}
# ).to_s
#
# puts RestClient.post(url,"hello")
