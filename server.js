var SerialPort = require('serialport');


listSerialPort();

function listSerialPort(){
  SerialPort.list(function (err, ports) {
    ports.forEach(function(port) {
      console.log(port);
      var myport = new SerialPort(port.comName, {
        baudRate: 9600,
        autoOpen: false,
        parser: SerialPort.parsers.readline('\r\n'),
      });
      openSerialPort(myport);
      return;
    });
  });
}
function openSerialPort(port){
  port.open(function (err) {
    if (err) {
      return console.log('Error opening port: ', err.message);
    }
    console.log("Port opening at : "+port.path);
    listeningSerialPort(port);
  });
}
function listeningSerialPort(port){
  port.on('data', function (data){
    console.log(data);
    if(data == "test"){
      port.write("Hello\n");
    }
  });
}
