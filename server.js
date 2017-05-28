var SerialPort = require('serialport');
var mysql = require('mysql');

var db = mysql.createConnection({
  	host     : '127.0.0.1', //port 3306 for MariaDB
  	user     : 'root',
	  password : 'arttra88',
    database : 'smart-movie-ticket',
});

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
    var receiveData = data.split(";");
    var card_id = receiveData[0];
    var timestamp = receiveData[1];
    console.log("Card ID = "+card_id);
    console.log("Timestamp = "+timestamp);
    var query = "SELECT DISTINCT movie.m_name , shows.showDate , shows.st_time , hall.hall_name , seats.seat_id FROM customer ";
    query += "INNER JOIN tickets ON customer.id = tickets.Customer_id ";
    query += "INNER JOIN shows ON tickets.Show_show_id = shows.show_id ";
    query += "INNER JOIN movie ON shows.Movie_m_id = movie.m_id ";
    query += "INNER JOIN seats ON tickets.Seats_seat_id = seats.seat_id AND tickets.Seats_Hall_hall_id = seats.Hall_hall_id AND tickets.Seats_Hall_Theatre_theatre_id = Seats.Hall_Theatre_theatre_id ";
    query += "INNER JOIN hall ON tickets.Seats_Hall_hall_id = hall.hall_id AND tickets.Seats_Hall_Theatre_theatre_id = hall.Theatre_theatre_id ";
    query += "WHERE customer.card_id = '" + card_id + "'";
    db.query(query, function (err, rows, fields) {
      if (err) throw err
      if(rows.length == 0){ //if doesn't find ticket
        console.log("Ticket Mismatch");
        port.write("Ticket Mismatch\n");
      }else{
        var movie_name = rows[0].m_name;
        var show_date = rows[0].showDate;
        var show_start_time = rows[0].st_time;
        var hall_name = rows[0].hall_name;
        var seat_id = rows[0].seat_id;
        var timestamp_date = timestamp.split(" ")[1];
        var timestamp_time = timestamp.split(" ")[2];
        var timestamp_hr = timestamp_time.split(":")[0];
        var timestamp_m = timestamp_time.split(":")[1];
        var timestamp_s = timestamp_time.split(":")[2];
        var timeshow_hr = show_start_time.split(":")[0];
        var timeshow_m = show_start_time.split(":")[1];
        var timeshow_s = show_start_time.split(":")[2];
        var timestamp_total_s = (parseInt(timestamp_hr)*3600) + (parseInt(timestamp_m)*60) + parseInt(timestamp_s);
        var timeshow_total_s = (parseInt(timeshow_hr)*3600) + (parseInt(timeshow_m)*60) + parseInt(timeshow_s);
        if( (timestamp_date != show_date) || ((timeshow_total_s-timestamp_total_s)>(15*60)) || ((timestamp_total_s-timeshow_total_s)>(45*60)) ){
          console.log("Not in time");
          port.write("Not in time\n");
        }
        else{
          console.log(movie_name+" "+show_date+" "+show_start_time+" "+hall_name+" "+seat_id);
          port.write(movie_name+";"+show_start_time+";"+hall_name+";"+seat_id+"\n");
        }
      }
    });
  });
}
