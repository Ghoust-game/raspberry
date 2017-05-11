#!/usr/bin/env python
"""
This app listens for a specific MQTT messages
and triggers the update scripts.
"""
import os
import paho.mqtt.client as mqtt

MQTT_TOPIC_PERFORM_UPDATE = "GHOUST/server/perform-update"
CMD_UPDATE = "/server/raspberry/scripts/execute_update.sh"
CMD_PUBLISH_VERSIONS = "/server/raspberry/scripts/mqtt_version_publisher.sh"

class Updater:
    mqtt_client = None

    def run(self):
        os.system(CMD_PUBLISH_VERSIONS)
        self.mqtt_client = mqtt.Client("GHOUST_UPDATER", clean_session=False)

        self.mqtt_client._on_connect = self.mqtt_on_connect
        self.mqtt_client._on_message = self.mqtt_on_message

        # self.mqtt_client.connect("ghoust.local", 1883, 60)
        self.mqtt_client.connect("localhost", 1883, 60)
        self.mqtt_client.loop_forever()

    def mqtt_on_connect(self, a, b, c, d):
        print("on connect")
        self.mqtt_client.subscribe(MQTT_TOPIC_PERFORM_UPDATE)

    def mqtt_on_message(self, client, userdata, msg):
        print("on message %s, %s" % (msg.topic, msg.payload))
        if msg.topic == MQTT_TOPIC_PERFORM_UPDATE:
            print("execute update and quit!")
            self.mqtt_client.disconnect()
            os.system(CMD_UPDATE)
            return


if __name__ == "__main__":
    updater = Updater()
    updater.run()
