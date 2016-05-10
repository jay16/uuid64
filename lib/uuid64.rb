require 'securerandom'
require 'socket'
require 'digest'
module SecureRandom
  def SecureRandom.uuid64
    [[SecureRandom.uuid.gsub(/-/, '')].pack('H*')].pack('m').gsub(/==/,'').gsub(/\n/,'')
  end
  def SecureRandom.mongo_id
    if @mongo_init.nil?
      @mongo_init = true
      @mongo_host = Digest::SHA2.hexdigest(Socket.gethostname)[0..5].freeze
      @mongo_pid = Process.pid.to_s(16)[0..3].rjust(4, '0')
      @mongo_inc = 0
    else
      @mongo_inc += 1
    end

    Time.now.to_i.to_s(16)[0..15].rjust(8, '0')[0..7] +
        @mongo_host +
        @mongo_pid +
        @mongo_inc.to_s(16).rjust(6, '0')[0..5]
  end
  def SecureRandom.mongo_id64
    [[SecureRandom.mongo_id].pack('H*')].pack('m').gsub(/\n/,'')
  end
end