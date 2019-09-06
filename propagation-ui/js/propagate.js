function propagate() {
  var radio_horizon = 0
  var antenna_height = $("#transmitter-antenna-height > input").val()
  var NRanges = 10
  var transmitter_antenna_pattern = $("#transmitter-antenna-pattern").val()
  var transmitter_antenna_pattern_id = ""
  var transmitter_antenna_pattern_data = []
  var transmitter_antenna_pattern_maximum_linear = 1
  async.series([
    function(callback){
      $.get("/bash/api/propagation-radiohorizon?height=" + antenna_height, function(res) {
        if (!res.error && res.exit == 0) {
          radio_horizon = Number(res.output)
        }
        callback(null)
      })
    
    },
    function(callback){
      var url = "/database/api/v1/antenna/pattern"
      var data = {name: transmitter_antenna_pattern}
      var success = function(data){
        var err = null
        if(data){
          transmitter_antenna_pattern_data = data[0].data
          transmitter_antenna_pattern_id = data[0]._id
        }
        else{
          err = "no pattern"
        }
        //console.log(data)
        console.log(transmitter_antenna_pattern_id)
        console.log(transmitter_antenna_pattern_data)
        callback(err)
      }
      $.get(url, data, success)
    },
    function(callback){
      var url = "/bash/api/json-find-max"
      var data = {database:"antenna", collection:"pattern", id: transmitter_antenna_pattern_id, key:"[.data[].amp]"}
      var success = function(data){
        var err = null
        if(!data.error && data.exit == 0){
          transmitter_antenna_pattern_maximum_linear = Math.pow(10,Number(data.output)/10)
        }
        else{
          err = "error in bash call"
        }
        //console.log(data)
        console.log(transmitter_antenna_pattern_maximum_linear)
        callback(err)
      }
      $.get(url, data, success)
    },
    function(callback){
      var coll = transmitter_antenna_pattern_data
      var iteratee = function(item, callback){
        var pattern_amplitude_for_angle_linear = Math.pow(10, item.amp/10)
        var radio_horizon_for_angle = radio_horizon * Math.sqrt(pattern_amplitude_for_angle_linear/transmitter_antenna_pattern_maximum_linear)
        console.log(radio_horizon_for_angle)
        callback(null)
      }
      var callback2 = function(err){
        callback(null)    
      }
      async.each(coll, iteratee, callback2)
    }

  
  ], function(err){console.log("Finished")})

}
