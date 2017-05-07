#!/usr/bin/env python
import os
import paho.mqtt.client as mqtt

MQTT_TOPIC_PERFORM_UPDATE = "GHOUST/server/perform-update"
CMD_UPDATE = "/server/raspberry/scripts/execute_update.sh"

class Updater:
    mqtt_client = None

    def run(self):
        self.mqtt_client = mqtt.Client("GHOUST_UPDATER", clean_session=False)

        self.mqtt_client._on_connect = self.mqtt_on_connect
        self.mqtt_client._on_message = self.mqtt_on_message

        # self.mqtt_client.connect("ghoust.local", 1883, 60)
        self.mqtt_client.connect("localhost", 1883, 60)
        self.mqtt_client.loop_forever()

    def mqtt_on_connect(self, a, b, c, d):
        print("on connect")
        self.mqtt_client.subscribe("GHOUST/server/perform-update")

    def mqtt_on_message(self, client, userdata, msg):
        print("on message %s, %s" % (msg.topic, msg.payload))
        if msg.topic == MQTT_TOPIC_PERFORM_UPDATE:
            print("execute update!")
            self.mqtt_client.disconnect()
            os.system(CMD_UPDATE)
            return


updater = Updater()
updater.run()
