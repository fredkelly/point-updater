require 'bundler'
Bundler.require

require 'yaml'
require 'point'
require 'highline/import'

#------------------------------------------------------------

# add nice to_s to record
class Point::ZoneRecord
  def to_s
    "#{record_type}\t#{name}\t#{data}"
  end
end

#------------------------------------------------------------

# are we updating the config?
update = ARGV.first == '--update'

# grab config file
config = YAML::load_file(File.dirname(__FILE__) + '/config.yml') rescue {}

# get api details
point_username = config[:point_username] || ask('username:')
point_apitoken = config[:point_apitoken] || ask('api token:')

# setup point api connection
Point.username = point_username
Point.apitoken = point_apitoken

# if not configured..
if config.empty? || update
  # get available zones
  zones = Point::Zone.find(:all)

  puts "Zones for \"#{point_username}\".."

  # choose target zone
  target_zone = nil
  choose do |menu|
    menu.prompt = 'Please select target zone..'
    zones.each do |zone|
      menu.choice(zone.name) { target_zone = zone }
    end
  end

  puts "Records for \"#{target_zone.name}..\""

  # choose target record
  target_record = nil
  choose do |menu|
    menu.prompt = 'Please select target record..'
    target_zone.records.each do |record|
      menu.choice(record) { target_record = record }
    end
  end

  # create config
  config = {
    :point_username => point_username,
    :point_apitoken => point_apitoken,
    :target_zone    => target_zone.id,
    :target_record  => target_record.id
  }
  
  # save it!
  File.open('./config.yml', 'w') do |file|
    YAML.dump(config, file)
  end
else
  # user configured values
  target_zone = Point::Zone.find(config[:target_zone])
  target_record = target_zone.record(config[:target_record])
end

#------------------------------------------------------------

# get your external ip address
my_ip = %x(+short myip.opendns.com @resolver1.opendns.com).chomp

# set record to your ip
target_record.data = my_ip

# save it!
if target_record.save
  puts "Updated \"#{target_record.name}\" -> #{target_record.data} :-)"
end