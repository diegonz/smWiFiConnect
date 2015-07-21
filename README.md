# SmartWiFiConnect ESP-01 *(LAN & WAN)*

[TOC]

## Conexión a WiFi
### Protocolo de configuración inalámbrica
1. Comprobación periódica *(1 seg)* del estado de la *auto-conexión* *("init.lua")*.
2. En caso de timeout *(30 seg)* o fallo en la conexión *(error, pwd erróneo, wifi no encontrado...)* arrancamos el **modo AP** .
	1. Arrancamos el **modo AP** *("smConfConn.lua")*.
	2. Configuramos los ajustes del **modo AP** *("smAPConfData.lua")*.
	3. Escaneamos las redes disponibles y las almacenamos.
	4. En la IP *192.168.4.1* devolvemos una página web con las redes disponibles.
	5. Conectamos con la red indicada en la página web.
3. Lanzamos la *smartApp* correspondiente *(Ej:"smDimmer.lua")*.

## Conexión a Internet
### Protocolo ESP-01 -> socketServer

1. Apertura de conexión contra el puerto 2525.
2. Procesado del saludo de servidor.
3. Envío de la ID de *smartdevice* basada en la dirección MAC.
4. Procesado de la respuesta de autenticación del servidor.
5. Procesado de los distintos datos recibidos a través del socket.

## Conexión a Cliente LAN
### Protocolo ESP-01 <- Cliente LAN

1. Escucha en el puerto 2525.
2. Recepción del *payload* en formato **`DEVICE-ID:COMMAND:DATA`** *(separado por dos puntos `:`)*
	- El argumento `DEVICE-ID` será en formato **`SMARTIDEA-XX-YY`**, donde *XX* e *YY* son los cuatro últimos dígitos de la MAC.
	- Los argumentos aceptan caracteres alfanuméricos y el guión medio `-`.
3. Envío de la respuesta por parte del smart device.
	- El smart device responderá devolviendo los datos solicitados a través del socket finalizados por `\r\n`.
	- Devolverá mensajes en caso de error en los argumentos. Si el error se produce en la comprobación del `DEVICE-ID`, pero si el parámetro pasado como `DEVICE-ID` es exactamente `getdeviceid` el smart device devolverá el `DEVICE-ID` *correcto*.

#### Comandos disponibles para el *payload*
- `print` - Escribe los datos recibidos en `DATA` por el puerto serie y los devuelve por el socket.
- `restart` - Reinicia el smart device.
- `getip` - Devuelve por el socket la dirección IP del smart device.
- `getmac` - Devuelve por el socket la dirección MAC del smart device.
- `getwlancfg` - Devuelve por el socket la configuración de la WLAN actual del smart device.


[Smartidea ®](http://smartidea.es)