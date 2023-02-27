$(function(){
    console.log("ok...");
    $('#idFind').click(function(){
   	console.log($('#name').val(), $('#phone').val())
   	 var user = {name: $('#name').val(), phone: $('#phone').val()} 
    $.ajax({
        url: "/web/rest/getId",
        type: "POST",
        contentType : "application/json; charset=UTF-8",
        dataType : "text",
        data : JSON.stringify(user),
      	success: function(data, textStatus){
          console.log(data, textStatus);
          location.href = "/web/users/getIdFind?user_id=" + data;
        },
        error: function(data, textStatus){
         console.log(data.responseText, textStatus)
         alert(data.responseText);
         }
      });
        
    })
})

