$(document).ready(function(){

  $("#testAjax").on('submit', function(e){
    e.preventDefault()
    serializedData = $(this).serialize()
    console.log(serializedData)
    $.ajax({
                type: "POST",
                // contentType: "application/json; charset=utf-8",
                url: `/sessions`,
                //data: "{'data1':'" + value1+ "', 'data2':'" + value2+ "', 'data3':'" + value3+ "'}",
                data: serializedData,
                dataType: "json",
                success: function (result) {
                //do somthing here
                    console.log("success!!");

                },
                error: function (){
                  console.log("something wrong!");
                }
            });
  })


});
