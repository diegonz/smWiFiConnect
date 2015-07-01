# SmartWiFiConnect ESP-01 *(WiFi e Internet)*

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


[Smartidea ®](http://smartidea.es)