require 'base64'
require 'openssl'
require 'digest/sha1'


module TracksHelper
	def policy_document
<<-policy
{"expiration": "2020-01-01T00:00:00Z",
"conditions": [ 
  {"bucket": "fireworktracks"}, 
  ["starts-with", "$key", ""],
  {"acl": "private"},
  {"success_action_redirect": "http://example.com/upload_callback"},
  ["starts-with", "$Content-Type", ""],
  ["content-length-range", 0, 524288000]
]
}
policy
	end

	def policy
		Base64.encode64(policy_document).gsub("\n","")
	end

	def signature
		Base64.encode64(
	    OpenSSL::HMAC.digest(
	        OpenSSL::Digest::Digest.new('sha1'), 
	        ENV['AWS_SECRET_ACCESS_KEY'], policy)
	    ).gsub("\n","")
	end
end
