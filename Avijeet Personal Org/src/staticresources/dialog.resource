var sd,sd2;
function openSimpleDialog(){
	var htmlBody = "<p align='center'><img src='/img/msg_icons/confirm32.png' style='margin:0 5px;'/></p><embed width='100%' height='100%' name='plugin' src='https://avijeet-avijeet-dev-ed--c.ap1.visual.force.com/apex/pdftest' type='application/pdf'><p align='center'>This is awesome!</p><p align='center'><br /><button class='btn' onclick='sd.hide(); return false;'>cancel</button></p>";
	sd = showSimpleDialog('SimpleDialog',htmlBody,false);
}

function openSimpleDialogDraggable(){
	var htmlBody = "<p align='center'><img src='/img/msg_icons/confirm32.png' style='margin:0 5px;'/></p><p align='center'>Hey! Look I am draggable</p><p align='center'><br /><button class='btn' onclick='sd2.hide(); return false;'>cancel</button></p>";
	sd2 = showSimpleDialog('SimpleDialog',htmlBody,true);
}

/*Simple dialog reusable function*/
function showSimpleDialog(title,htmlBody,isDraggable){    
   var sd = new SimpleDialog("SD"+Dialogs.getNextId(), isDraggable);    
   sd.setTitle(title);    
   sd.createDialog();  
   sd.setWidth(1000);
   sd.setContentInnerHTML(htmlBody);    
   sd.show();   
   return sd;   
}