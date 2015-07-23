$:.unshift(File.dirname(__FILE__))

require 'test_helper'

class MqttSnSubTest < Minitest::Test

  def test_usage
    @cmd_result = run_cmd('mqtt-sn-sub', '-?')
    assert_match /^Usage: mqtt-sn-sub/, @cmd_result[0]
  end

  def test_subscribe_one
    fake_server do |fs|
      @packet = fs.wait_for_packet(MQTT::SN::Packet::Subscribe) do
        @cmd_result = run_cmd(
          'mqtt-sn-sub',
          ['-1', '-v',
          '-t', 'test',
          '-p', fs.port]
        )
      end
    end
    
    assert_equal ["test: Hello World\n"], @cmd_result
    assert_equal 'test', @packet.topic_name
    assert_equal :normal, @packet.topic_id_type
    assert_equal 0, @packet.qos
  end
  end

end
