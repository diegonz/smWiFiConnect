# Conexión ESP-01 (WiFi e Internet)

## Conexión a WiFi
### Protocolo de configuración inalámbrica
1. Comprobación del estado de la auto-conexión periódicamente *(1 seg)*.
2. En caso de timeout *(30 seg)* o fallo en la conexión *(error, pwd erróneo, wifi no encontrado...)* arrancamos el **modo AP** *("smConfConn.lua")*.
	1. arrancamos el **modo AP**
	2. Configuramos los ajustes del **modo AP** *("smAPConfData.lua")*
	3. Escaneamos las redes disponibles y las almacenamos.
	4. En 192.168.4.1 devolveremos página web 

## Conexión a Internet
### Protocolo ESP-01 <-> socketServer

1. Apertura de conexión.
2. Lectura del saludo del servidor.
3. Envío de la ID de smartdevice