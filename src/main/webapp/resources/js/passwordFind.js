$(function(){
    console.log("ok...");
    $('#passwordFind').click(function(){
   	console.log($('#user_id').val(), $('#phone').val())
   	 var user = {user_id: $('#user_id').val(), phone: $('#phone').val()} 
    $.ajax({
        url: "/web/rest/getPw",
        type: "POST",
        contentType : "application/json; charset=UTF-8",
        dataType : "text",
        data : JSON.stringify(user),
      	success: function(data, textStatus){
          console.log(data, textStatus);
          location.href = "/web/users/modifyPassword?unum=" + data;
        },
        error: function(data, textStatus){
         console.log(data.responseText, textStatus)
         alert(data.responseText);
         }
      });
        
    })
})

