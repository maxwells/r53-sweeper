require 'aws-sdk'
require 'resolv'
require './lib/sweeper'

AWS.config({
  :access_key_id => ENV['AWS_ACCESS_KEY'],
  :secret_access_key => ENV['AWS_SECRET_KEY']
})

r53 = AWS::Route53.new
hosted_zone = r53.hosted_zones[ENV['HOSTED_ZONE_ID']]

sweeper = Sweeper.new
sweeper.hosted_zones << hosted_zone
unresolvable = sweeper.find_unresolvable

puts "name\ttype\tvalues"
unresolvable.each{|rrset|
  puts "#{rrset.name}\t#{rrset.type}\t#{rrset.resource_records.map{|rr| rr[:value]}.join "\t"}"
}