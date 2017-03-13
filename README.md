# SmartWiFiConnect ESP-01 / ESP-12 *(LAN, WAN & UART)*

[TOC]

## WiFi Connection
### Wireless setup protocol
1. Fixed polling *(1 seg)* of *auto-connection* status *("init.lua")*.
2. In case of timeout *(30 seg)* or connection error *(error, wrong pwd, SSID not found...)* start the **StationAP** mode.
	1. Start the **StationAP** mode *("smConfConn.lua")*.
	2. Setup **StationAP** mode settings *("smAPConfData.lua")*.
	3. Scan available networks and store them to build the web page.
	4. Requesting a webpage at IP *192.168.4.1* a barebones webpage is returned showing available networks.
	5. Connect to given wireless network using received _form_ data.
3. Launching the relevant App *(Ex:"smDimmer.lua")*.

## Aplicación
### Conexión a Internet
#### Protocolo ESP-01 -> socketServer

1. Open connection against port 8992.
2. Send _Auth request_, format: `{ "action" : "DEVICE_AUTH", "id" : "DEVICE-ID" }`.
3. Send *smartdevice* ID based on hardware MAC address.
4. Process server auth response.
5. Process the _JSON_ data received through the socket.

##### _Auth_ and authenticated use example
The devices and clients interact by exchanging _JSON_ objects, below we can see basic examples of _Auth_ and sending _info_ and _resources_.
- Device _Auth_ example

```
{ "action" : "DEVICE_AUTH", "id" : "123456" }
```
- Client _Auth_ example

```
{ "action" : "CLIENT_AUTH", "id" : "256956998", "account" : "myaccount1@myserver.es", "password" : "mypassword1" }
{ "action" : "CLIENT_AUTH", "id" : "256456328", "account" : "myaccount2@myserver.es", "password" : "mypassword2" }

```
- Received command samples:

```
{ "id" : "123456", "on" : true, "dimm" : 35 , "timmer" : false }
{ "id" : "345987", "on" : false, "dimm" : 10 , "timmer" : true }
{ "id" : "123457", "on" : true, "dimm" : 35 , "timmer" : false }
```

### LAN Client connection
#### ESP-01 <- LAN_Client Protocol

1. Listen at port 2525.
2. Receive *payload (stringBuffer)* with a simple `JSON` format:
	- The *payload* format **`{deviceID:SMART-XX-YY,smCommand:COMMAND,smData:DATA}`**.
	- The part `deviceID` is proposed as **`SMART-XX-YY`**, where *XX-YY* are the last four elements of the MAC address.
3. Send response.
	- The smartdevice will respond by returning the requested data through the socket in a *string* in `JSON` format.
	- In case of error, it will return an informative message in the `smData` field and the requested command in` smCommand`. If the error occurs in the `DEVICE-ID` check, but the passed parameter as` DEVICE-ID` is exactly `getdeviceid` the smart device will return the correct` DEVICE-ID` *.

##### Available *payload commands (stringBuffer)*
The *API* del smart device soporta los siguientes comandos *(smCommand)*:
- `send` - Sends **the first command (byte)** received in `smData`.
- `print` - Write the received data in `DATA` to the serial port and returns it through the socket too.
- `restart` - Reboots the smartdevice returning confirmation.
- `getip` - Returns the device IP address.
- `getmac` - Returns the MAC address of the smart device over the socket.
- `getwlancfg` - Returns through the socket the current WLAN config of the smartdevice *(SSID, PASSWORD, BSSID_SET and BSSID)*.

### UART to PIC microcontroller connection
When launching the relevant Smartidea App *(Ex: smDimmer)* the *UART* will be configured to connect to the * PIC * with the following parameters:

- `id = 0` - id de la *UART* *(NodeMCU only supports one, but is needed anyway)*.
- `baud = 115200`
- `databits = 8`
- `parity = none`
- `stopbits = 1`
- `echo = 0`

Currently a *callback* event is attached to the *UART* to receive a byte and send it through the socket in a * JSON * object built as follows:

- `smDevice : SMART-XX-YY`
- `smCommand : picdata`
- `smData : data` - *Data received from PIC*.
