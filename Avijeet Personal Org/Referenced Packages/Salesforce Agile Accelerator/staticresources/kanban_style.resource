
@font-face{font-family:'ProximaNova';src:url(/resource/agf__proximanovasoft_regular_webfont) format('truetype');font-weight:300;font-style:normal;}
@font-face{font-family:'ProximaNova';src:url(/resource/agf__proximanovasoft_medium_webfont) format('truetype');font-weight:500;font-style:normal;}
@font-face{font-family:'ProximaNova';src:url(/resource/agf__proximanovasoft_semibold_webfont) format('truetype');font-weight:700;font-style:normal;}
@font-face{font-family:'ProximaNova';src:url(/resource/agf__proximanovasoft_bold_webfont) format('truetype');font-weight:900;font-style:normal;}

div.bodyDiv,div.bodyDiv td{font-family:'ProximaNova','Lucida Grande','Arial';font-size:13px;color:#666;}
div.bodyDiv *{box-sizing:border-box;}
body .bodyDiv #bodyTable{padding:0px !important;}
/*
body{font-family:'ProximaNova','Lucida Grande','Arial';font-size:13px;}
button{font-family:'ProximaNova','Lucida Grande','Arial';font-size:13px;}
*/
#kanbanContainer{position:relative;border:2px #C0C0C0 solid;background-color:#F2F2F2;border-radius:10px;padding-top:42px;overflow:hidden;-webkit-transition-duration:0.3s;-moz-transition-duration:0.3s;-o-transition-duration:0.3s;transition-duration:0.3s;}
.ui-dialog button{height:auto !important;border-radius:5px !important;}
.ui-dialog button:hover{background-color:#DCDCDC;}
.ui-dialog button[disabled]:hover{background:transparent;}
.ui-dialog button[disabled] span{color:#838383 !important;}
#kanbanContainer button,
.ui-dialog button{font-family:'ProximaNova','Lucida Grande','Arial';font-size:13px;border-radius:0;display:inline-block;text-decoration:none;padding:0px 10px;background:transparent;border:0;cursor:pointer;margin:0;height:42px;-webkit-appearance:none;outline:0;}
#kanbanContainer button:hover,
.ui-dialog button:hover{background-color:#DCDCDC;}
#kanbanContainer button:active,
.ui-dialog button:active{background-color:#C0C0C0;}
.ui-dialog button:active{border:1px #C0C0C0 solid;}
#kanbanContainer button span,
.ui-dialog button span{display:inline-block;margin:0px;padding:5px;font-size:12px;color:#333;font-weight:bold;}
#kanbanContainer button .fa,
.ui-dialog button .fa{color:#333;font-size:13px;}
#kanbanContainer button i.fa{margin-left:5px;font-size:12px;}
#kanbanContainer #kanbanLoading{display:none;}
.ui-dialog button{border:1px #C0C0C0 solid;background:#E8E8E8;}
#kanbanContainer #kanbanFailed button:hover,
#kanbanContainer.boardloading #kanbanLoading{display:block;position:absolute;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);border-radius:8px;text-align:center;}
#kanbanContainer.boardloading #kanbanLoading .fa{color:#fff;font-size:30px;margin-top:200px;}
#kanbanContainer #dragDropContainment{position:absolute;left:0;top:0;right:0;bottom:0;/* border:1px red solid; */margin:40px -22px -20px -22px;z-index:-1;}
#containerToolbar{font-weight:bold;position:absolute;top:0;left:0;right:0;background-color:#E8E8E8;height:42px;line-height:42px;/* border-bottom:1px #C0C0C0 solid; */box-shadow:0px 2px 4px #666;z-index:1;border-top-right-radius:10px;border-top-left-radius:10px;}
#toolbarTitle{text-align:center;font-size:18px;color:#888;text-shadow:0px 0px 3px #FFF;}

#kanbanContents > .containerColumns:first-child > .holderContents:last-child > .holderWork{max-height:600px;} /* quick fix for closed column */

#toolbarButtonsLeft{position:absolute;left:0px;top:0px;}
#toolbarButtonsLeft li{border-right:1px #CECECE solid;}
#toolbarButtonsLeft li:first-child button{border-top-left-radius:7px;}
#toolbarButtonsRight{position:absolute;right:0px;top:0px;}
#toolbarButtonsRight li{border-left:1px #CECECE solid;}
#toolbarButtonsRight li:last-child button{border-top-right-radius:7px;}
.toolbarButtons{padding:0;margin:0;list-style-type:none;font-size:0;height:42px;overflow:hidden;}
.toolbarButtons li{display:inline-block;}
	
#kanbanContents{overflow:auto;}
.containerColumns{display:table;width:100%;/*table-layout:fixed;*/}
.columnsRow{display:table-row;height:100%;}
.columnsHolder{display:table-cell;height:100%;padding:0px;}
.columnsHolder:last-child{border-right:0;}

.holderContents{display:table-cell;border-right:1px #C0C0C0 solid;overflow:hidden;/*background:orange;*/}
.holderContents:last-child{border-right:0;}
.holderTitle{background-color:#666;padding:7px 10px;color:#fff;text-align:center;font-size:13px;/* text-transform:uppercase; */border-top:1px #C0C0C0 solid;height:36px;}
.holderWork{min-width:217px;overflow-y:auto;overflow-x:hidden;min-height:97px;}
#parent-0-row-0 > .holderContents > .holderTitle{border-top:0;} /* remove top border on titles */

.titleText{display:block;color:#fff;white-space:nowrap;}
.titleOptions .fa{font-size:14px;font-weight:normal;color:#fff;margin:-3px 2px 0px 2px;}
.titleOptions .fa:hover{color:#C8E27C;cursor:pointer;}
#titleOptionsLeft{float:left;}
#titleOptionsRight{float:right;}

.progress{display:inline-block;position:relative;width:100px;max-width:100%;background-color:#464646;border:1px #797979 solid;}
.progressLeft{position:absolute;top:0;bottom:0;left:0;width:0%;background:#C8E27C;}
span.progressTitle{padding-left:4px;color:#ccc;font-size:11px;}
div.progressTitle{padding:2px;}

/* work card */
.card{display:block;min-width:200px;max-width:200px;margin:10px auto;cursor:default;position:relative;}
.card.highlight .inner-card{background-color:#FFF8C9;}
.card.ui-sortable-helper{transform:rotate(2deg);-ms-transform:rotate(2deg);-webkit-transform:rotate(2deg);}
.card.placeholder{opacity:0.4;}
.card .remove-card{display:none;cursor:pointer;position:absolute;right:-5px;top:-5px;background:#DDD;border:1px #9D9D9D solid;border-radius:10px;padding:1px 2px;font-size:10px;}
.card:hover .remove-card{display:block;}
.card:hover .remove-card:hover{color:#000;}
.card .inner-card{font-size:11px;vertical-align:top;display:block;background:#fff;border:1px #CCC solid;border-radius:5px;border-left-width:4px;}
.card .inner-card-subject{padding:10px;font-weight:bold;word-wrap:break-word;}
.card .inner-card-subject > div{float:right;margin-left:5px;margin-top:-5px;margin-right:-5px;}
.card .inner-card-names{display:none;vertical-align:middle;padding-right:5px;color:#777;font-size:11px;}
.card .inner-card-picture{display:table-cell;vertical-align:middle;}
.card .inner-card-picture img{width:25px;height:25px;border-radius:5px;}
.card .inner-card-toolbar{background:#ddd;color:#777;height:20px;overflow:hidden;}
.card .inner-card-toolbar > div{display:inline-block;padding:4px 5px;font-weight:bold;border-right:1px #ccc solid;}
.card .inner-card-toolbar > div > .fa-comment{position:relative;top:-1px;margin-left:2px;font-size:13px;}
.card .inner-card-toolbar > div > .fa-check-square-o{position:relative;top:1px;margin-left:2px;font-size:13px;}
.card .inner-card-toolbar > div.inner-card-toolbar-workid{padding:4px 5px;border-right:0;border-left:1px #ccc solid;float:right;font-weight:normal;font-size:10px;}
.card .inner-card-toolbar > div.inner-card-toolbar-workid > .fa{margin-right:3px;}
.card-bug .inner-card-toolbar > div.inner-card-toolbar-workid > .fa:before{content:"\f188";}
.card-bug .inner-card{border-left-color:#00A61B;}
.card-userstory .inner-card-toolbar > div.inner-card-toolbar-workid > .fa:before{content:"\f02d";}
.card-userstory .inner-card{border-left-color:#0067A6;}

/* dialog stuff */
.ui-widget-overlay{background:rgba(0,0,0,0.7);}
.ui-button{border:0;outline:0;border-radius:5px;cursor:pointer;}
.ui-button:hover{background:#E7E7E7;}
.ui-dialog-titlebar-close{display:none;}
.ui-dialog{display:none;background:#E8E8E8;border-radius:10px;font-size:13px;color:#666;min-height:0 !important;box-sizing:border-box;}
.ui-dialog *{box-sizing:border-box;}
.ui-button-text-only .ui-button-text{color:#333;font-weight:bold;}
.ui-dialog input[type=text],
.ui-dialog input[type=number],
.ui-dialog select,
.ui-dialog textarea{display:block;font-family:'ProximaNova','Lucida Grande','Arial';font-size:13px;padding:5px;border:1px #C0C0C0 solid;outline:0;border-radius:5px;}
.ui-dialog select{height:27px;}
.ui-dialog textarea{resize:none;height:100px;}
.ui-dialog #customcolor{display:block;margin-bottom:20px;}
.ui-dialog .message{margin:0;border:0;background:none;color:#fff;padding:0;}
.ui-dialog li{margin-bottom:10px;}
.ui-dialog .ui-dialog-buttonpane{margin-top:0;border-top:1px #BEBEBE solid;}
.ui-dialog .ui-dialog-title{font-weight:bold;}
.ui-dialog .ui-dialog-titlebar{background:#666;border-radius:5px;margin:3px;color:#fff;}
.ui-dialog .ui-dialog-titlebar-close{display:none !important;}
.ui-dialog-error{display:none;margin-top:10px;padding:5px 10px;background:#C03300;color:#FFF;border-radius:5px;}

/* settings */
#settingsDialog .settingsColumn{background:#666;border-color:#E8E8E8;display:table-cell;border-right:1px #C0C0C0 solid;overflow:hidden;}
#settingsDialog .settingsColumn:last-child{border-right:0;}
#settingsDialog .settingsColumn.highlight{background:#005B99;outline:0;}
/*#settingsDialog .settingsColumn.highlight > .containerColumns > .settingsColumn{background:none;}*/
#settingsDialog .settingsColumn.remove{display:none;}
#settingsDialog .settingsColumn .holderTitle{background:none;height:auto;}
#settingsDialog .settingsColumn.settingsSwimlane > .holderTitle{border-top-width:5px;}
#settingsDialog .holderTitle{border-color:#E8E8E8;}
#settingsDialog #kanbanSettingsContents{user-select:none;-webkit-user-select:none;-moz-user-select:none;overflow:auto;position:relative;}
#settingsDialog #kanbanSettingsContents *{cursor:pointer;}
#settingsDialog #kanbanSettingsLoading{display:none;}
#settingsDialog.boardloading #kanbanSettingsLoading{display:block;position:absolute;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);text-align:center;z-index:10;}
#settingsDialog.boardloading #kanbanSettingsLoading .fa{color:#fff;font-size:30px;margin-top:60px;}
#settingsDialog #propertyPanel{position:relative;}
#settingsDialog .propertyHeader{margin-top:20px;border-bottom:1px #BEBEBE solid;margin-bottom:8px;padding-bottom:3px;font-weight:bold;}
#settingsDialog .propertyFormOptions{visibility:hidden;}
#settingsDialog .propertyFormOptions label{white-space:nowrap;}
#settingsDialog #closePanelHolder{position:absolute;top:0px;right:4px;}
#settingsDialog #closePanelHolder .fa{font-size:18px;}
#settingsDialog #columnNameTitle{text-transform:uppercase;margin-top:15px;font-size:14px;}
#settingsDialog #closePanel{cursor:pointer;}
#settingsDialog #workExists,
#settingsDialog #childrenExist{margin-bottom:10px;display:none;}
#settingsDialog #createStatusMappingHolder{display:none;}
#settingsDialog .statusesText{font-size:10px;color:#61D5FF;text-transform:uppercase;}
#settingsDialog span.progressTitle{display:none;padding:0px 4px;color:#4D4D4D;font-size:11px;background:#CCC;border-radius:4px;top:-2px;position:relative;font-weight:bold;}
button#saveButton{display:none;}
button#saveButton[disabled]{border:1px transparent;}

/* backlog dialog */
.workList{background:#fff;height:300px;width:100%;overflow-y:auto;border:1px #C0C0C0 solid;border-radius:5px;user-select:none;-webkit-user-select:none;-moz-user-select:none;}
.workList .spacer{padding-top:5px;text-align:center;}
#backlogDialogHeader{margin-bottom:12px;}
#backlogColumnSelect{display:inline-block;}
.backlogRow:first-child > div{padding-top:10px;}
.backlogRow:hover > div{background-color:#E4E4E4;}
.backlogRow > div{display:table-cell;padding:2px 5px;}
.backlogRow > div.backlogSubject{width:100%;}
.backlogRow > div.backlogSubject label{display:block;}
.backlogRow > div.backlogWorkId{white-space:nowrap;}
#backlogDialog #backlogDialogLoading{display:none;}
#backlogDialog.dialogloading #backlogDialogLoading{display:block;position:absolute;top:0;left:0;right:0;bottom:0;background:rgba(0,0,0,0.5);text-align:center;z-index:10;}
#backlogDialog.dialogloading #backlogDialogLoading .fa{color:#fff;font-size:30px;margin-top:220px;}
#backlogDialog .ui-dialog-error{margin-bottom:10px;}

/* filter dialog */
#filterDialog{position:fixed;top:124px;opacity:0;left:-185px;padding:10px;z-index:2;display:inline-block;width:200px;-webkit-transition-duration:0.3s;-moz-transition-duration:0.3s;-o-transition-duration:0.3s;transition-duration:0.3s;height:830px;overflow:auto;}
.itemList{display:table;width:100%;background:#F0F0F0;overflow-y:auto;border:1px #C0C0C0 solid;border-radius:5px;margin:5px 0px 15px 0px;user-select:none;-webkit-user-select:none;-moz-user-select:none;}
.itemList:last-child{margin-bottom:0;}
.itemList .spacer{padding-top:5px;text-align:center;}
/*.itemRow:first-child > div{padding-top:10px;}*/
.itemRow{display:table-row;}
.itemRow:hover > div{background-color:#DDD;}
.itemRow:first-child:hover > div:first-child{border-top-left-radius:5px;}
.itemRow:first-child:hover > div:last-child{border-top-right-radius:5px;}
.itemRow:last-child:hover > div:first-child{border-bottom-left-radius:5px;}
.itemRow:last-child:hover > div:last-child{border-bottom-right-radius:5px;}
.itemRow > div{display:table-cell;padding:2px 5px;}
.itemRow > div.itemTitle{width:100%;}
.itemRow > div.itemTitle label{display:block;}
#filterDialog input[type=text]{margin:5px 0px 15px 0px;display:block;background:#F0F0F0;border:1px #C0C0C0 solid;border-radius:5px;padding:5px;outline:0;width:100%;}
#filterDialog input[type=text]:focus{background-color:#FFE;border-color:#AAA;}
#filterDialog #filterResults{margin-bottom:15px;}
#filterDialog .filterTopic{margin-bottom:15px;}

/* salesforce1 style tabs */
ul.sTabs{padding:0;margin:0;list-style:none;text-align:center;border-bottom:1px #BEBEBE solid;margin-bottom:12px;}
ul.sTabs > li{display:inline-block;margin:0;}
ul.sTabs > li > a,
ul.sTabs > li > a:hover{text-decoration:none;text-transform:uppercase;font-weight:bold;font-size:11px;color:#555;display:block;padding:7px 16px;outline:none;}
ul.sTabs > li.on > a{border-bottom:2px #0088E5 solid;}

/* fullscreen changes */
html.fullscreen{height:100%;}
html.fullscreen body{height:100%;margin:0px;background:#F2F2F2;overflow:hidden;}
html.fullscreen div#contentWrapper{height:100%}
html.fullscreen div.bPageHeader,
html.fullscreen div.bPageFooter{display:none;}
html.fullscreen div.bodyDiv{box-shadow:none;-webkit-box-shadow:none;background:none;border:0px;}
html.fullscreen table#bodyTable{height:100%;padding:0px;}
html.fullscreen td.noSidebarCell{padding:0px;vertical-align:top;height:100%;background:#fff;}
html.fullscreen #buttonFullscreen{background-color:#B8B8B8;}
html.fullscreen #kanbanContainer{border-radius:0px;border:0px;border-left:2px #C0C0C0 solid;width:auto;box-sizing:content-box;}
html.fullscreen #kanbanContainer *{box-sizing:border-box;}
html.fullscreen #filterDialog{top:10px;margin-left:-15px;}

#buttonFilter.selected{background-color:#B8B8B8;}