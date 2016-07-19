require 'securerandom'

class API
  @@array_count = 5

  @@available_api_keys = Array.new
  @@api_keys = Hash.new
  @@blocked_keys = Array.new
  @@blocked_time = Hash.new
  @@spawn_time = Hash.new

  def initialize
  end

  def self.generate_keys
    (0...@@array_count).each do |i|
      key = SecureRandom.urlsafe_base64
      @@available_api_keys << key
      @@api_keys[key] = :available
      @@spawn_time[key] = Time.now.to_i
      puts @@available_api_keys[i]
    end

    Thread.new do
      while true do
        check_obsolete
        sleep 5
      end
    end
    return "success"
  end

  def self.get_available_key
    puts "size = #{@@available_api_keys.length}"
    if @@available_api_keys.length == 0
      return "key_not_available"
    else
      key = @@available_api_keys.pop
      @@api_keys[key.to_sym] = :blocked
      @@blocked_keys << key
      @@blocked_time[key] = Time.now.to_i
      puts "time = #{@@blocked_time[key]}"
      return key
    end
  end

  def self.unblock(api_key)
    puts "unblocking = #{api_key}"
    @@available_api_keys << api_key
    @@api_keys[api_key.to_sym] = :available
    @@blocked_keys.delete(api_key)
    @@blocked_time.delete(api_key)
    "success"
  end

  def self.delete(api_key)
    @@available_api_keys.delete(api_key)
    @@api_keys.delete(api_key.to_sym)
    @@blocked_keys.delete(api_key)
    @@blocked_time.delete(api_key)
    @@spawn_time.delete(api_key)
    "success"
  end

  def self.live(api_key)
    @@spawn_time[api_key] = Time.now.to_i
    puts "time = #{@@spawn_time[api_key]}"
  end

  private
  def self.check_obsolete
    @@blocked_time.each do |key, time|
      if time < Time.now.to_i - (60)
        puts "unblocking key #{key}"
        unblock(key)
      end
    end

    @@spawn_time.each do |key, time|
      if time < Time.now.to_i - (5 * 60)
        puts "deleting obsolete key = #{key}"
        delete(key)
      end
    end
  end

end

#API::generate_keys
#puts API::get_available_key
