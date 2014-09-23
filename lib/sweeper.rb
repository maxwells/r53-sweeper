require 'aws-sdk'
require 'resolv'

class Sweeper
  attr_accessor :hosted_zones

  def initialize
    self.hosted_zones = []
    @resolver = Resolv::DNS.new nil # use /etc/resolv.conf
  end

  def find_unresolvable
    unresolvable = []

    hosted_zones.each {|zone|
      zone.resource_record_sets.each { |rrset|
        unresolvable << rrset unless can_resolve? rrset
      }
    }
    
    unresolvable
  end

  protected
  def can_resolve?(rrset)
    rrset.resource_records.each{|rr|
      begin
        @resolver.getaddress(rr[:value])
      rescue
        return false
      end
    }
    true
  end
end