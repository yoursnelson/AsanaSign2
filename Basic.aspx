<%@ Page Language="C#" CodeFile="Basic.aspx.cs" Inherits="_Basic" %>

<%@ Register Assembly="RadPdf" Namespace="RadPdf.Web.UI" TagPrefix="radPdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>Asana Signature</title>
	<meta name="viewport" content="width=device-width, user-scalable=no" />
</head>
   
<script language="javascript" type="text/javascript">


    function initRadPdf()
    {
        //get id
        var id = "<%= PdfWebControl1.ClientID%>";
        
        //get api instance
        api = new PdfWebControlApi(id);
        
        //add Event Listener for insert any object
        api.addEventListener(
            "objectAdded", objectAddedHandler);

        api.addEventListener(
                "saved",
                function(evt) {
                    //here is for postback, temp. disabled for testing purpose
                    //if (window.confirm("Save completed. Do PostBack?")) {
                    //__doPostBack(id, "");
                    __doPostBack(id, "");
                    window.location = "./Custom-Interface.aspx?id=<%=Session["id"]%>";
                    
                    //}
                });      


            
    }

    function objectAddedHandler(evt) {

        if (evt.obj.getType() == evt.obj.ObjectType.InkShape) {
            //display alert
            evt.obj.setProperties({ "lineColor": "#ff0000" });
//            evt.obj.setProperties({ "fillColor": "blue" });
//            evt.obj.setProperties({ "color": "blue" });
//            evt.obj.setProperties({ "border": { "color": "red"} });
//            evt.obj.setProperties({ "lineWidth": "2" });
            //window.alert("Image was added!");
        }
        //evt.obj.setProperties({ "border": { "color": '<%= Session["color"] %>'} });
        //evt.obj.setProperties({ "color": '<%= Session["color"] %>' });
        //evt.obj.setProperties({ "lineColor": '<%= Session["color"] %>' });
        
        
        if (evt.obj.getType() == evt.obj.ObjectType.TextShape) { //for inserting text objects
            //display alert
            evt.obj.setProperties({ "text": { "color": "#ffbb00"} });
            evt.obj.setProperties({ "font": { "color": '<%= Session["color"] %>'} });
            evt.obj.setProperties({ "border": { "color": "#ff0000"} });
            
            //window.alert("Image was added!");
        }
        
        if (evt.obj.getType() == evt.obj.ObjectType.RectangleShape) { // for inserting rectangle objects
            //display alert
            evt.obj.setProperties({ "fillColor": "transparent" });
            evt.obj.setProperties({ "border": { "color": "#ff0000"} });
            evt.obj.setProperties({ "border": { "color": "blue"} });
            //window.alert("Image was added!");
        }
    
        //evt.obj.setProperties({ "fillColor": "transparent" });
        //evt.obj.setProperties({ "border": { "color": "red"} });
        //window.alert(evt.obj.getType());
        
        //if this is an image
        if (evt.obj.getType() == evt.obj.ObjectType.EllipseShape) { // for inserting ellipse objects 
            //display alert
            //evt.obj.setProperties({ "fillColor": "transparent" });
            //evt.obj.setProperties({ "border": { "color": "#ff0000"} });
            //evt.obj.setProperties({ "border": { "color": "red"} });
            //window.alert("Image was added!");
        }
    }
     
     //function for showing hidden div
     function showDiv(id) {
         if (document.getElementById(id).style.display == "block") {
             document.getElementById(id).style.display = "none";
         } else {
            document.getElementById(id).style.display = "block";
         }
     };


function pausecomp(millis) 
 {
 var date = new Date();
 var curDate = null;

 do { curDate = new Date(); } 
 while(curDate-date < millis);
 } 
     //function for zooming at a defined position with specific page/location/zoom ratio
     //It can be used in further application as if zoom at the Signature field while user clicked "Sign"
     function zoomAtSignature( page, scrollX, scrollY, zoom){
        if(api)
        {
            var myApi = new PdfWebControlApi("PdfWebControl1"); // where "PdfWebControl1" is the ID (ClientID) assigned to the PdfWebControl instance
            myApi.setView({"page" : page, "zoom" : zoom, "scrollX" : scrollX, "scrollY" : scrollY}); 
            myApi.setMode(myApi.Mode.None);
        }
    };

    function zoomAndSign(page, scrollX, scrollY, zoom) {
    
        var myApi = new PdfWebControlApi("PdfWebControl1"); 
        var doctype = '<%= Session["doctype"] %>';
        
        if (doctype == "2")
        {
            page = "2";
            scrollX = "300";
            scrollY = "650";
            zoom = "80";
        
        }
        
        if (api) {
            //alert("here");
            var oldView = myApi.getView();
            
            var myApi = new PdfWebControlApi("PdfWebControl1"); // where "PdfWebControl1" is the ID (ClientID) assigned to the PdfWebControl instance
            //myApi.setView({ "page": 2 });
            //myApi.setView({ "scrollY": scrollY });
            //pausecomp(5500);
            //myApi.setView({ "page": page, "zoom": zoom, "scrollX": scrollX, "scrollY": scrollY });
            myApi.setView({ "page": page, "zoom": zoom, "scrollX": scrollX, "scrollY": scrollY });
            //myApi.setView({ "page": 2 });

            //myApi.setView({ "scrollY": 600 });
            //pausecomp(5500);

            myApi.setMode(myApi.Mode.InsertInkShape);
            var myView = myApi.getView();
            if (myView.page == 1)
            {
                alert("Please read through the whole document and ensure it is correct before sign on it.");
                myApi.setMode(myApi.Mode.none);
                myApi.setView({ "page": page, "zoom": oldView.zoom, "scrollX": scrollX, "scrollY": scrollY });
            }

            //document.getElementById("btnSign").click();
 
  
            //myApi.setView({ "page": page, "zoom": zoom, "scrollX": scrollX, "scrollY": scrollY });
        }
    };

    function sign() {
        if (api) {
            var myApi = new PdfWebControlApi("PdfWebControl1"); // where "PdfWebControl1" is the ID (ClientID) assigned to the PdfWebControl instance
            myApi.setMode(myApi.Mode.InsertInkShape);
        }
    }

    function rotateClockwise() {
        var myApi = new PdfWebControlApi("PdfWebControl1"); // where "PdfWebControl1" is the ID (ClientID) assigned to the PdfWebControl instance 

        //rotate the current page clockwise
        myApi.getPageViewed().rotatePage(90);

    };

    function rotateAntiClockwise() {
        var myApi = new PdfWebControlApi("PdfWebControl1"); // where "PdfWebControl1" is the ID (ClientID) assigned to the PdfWebControl instance 

        //rotate the current page anti-clockwise
        myApi.getPageViewed().rotatePage(-90);

    };
    
    
</script>

<body>
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <asp:Label ID="PdfSize" RunAt="server" />
    </div>
    <div style="text-align:center;">
    <!--
   <button onclick="if(api){api.setView( { 'page' : api.getView().page - 1 } );}return false;">Previous Page</button>
   <button onclick="if(api){api.setView( { 'page' : api.getView().page + 1 } );}return false;">Next Page</button>
   <br />
   <button onclick="if(api){rotateClockwise();}return false;">Rotate Clockwise</button>
   <button onclick="if(api){rotateAntiClockwise();}return false;">Rotate Anti-clockwise</button><br> 
   !-->
<button id="btnRefresh" onclick="location.reload(); ">&nbsp;&nbsp;&nbsp; Reload &nbsp;&nbsp;&nbsp;     </button>
   <button id="btnSign" onclick="zoomAndSign( 2,300, 650, 80);  return false;">&nbsp;&nbsp;&nbsp;&nbsp;Sign&nbsp;&nbsp;&nbsp;&nbsp;</button>
  <!--<button onclick="if(api){api.download();}return false;">Submit</button>-->
  <!--<button onclick="if(api){api.save();}return false;">Submit</button>-->
  <asp:Button ID="btnNext"  OnClientClick="if(api){api.save();}return false;" runat="server"  Text="   Submit   "/> 
   <!--
   <button onclick="showDiv('upload');return false;">Select File</button>
   &nbsp;&nbsp;<br /><button onclick="zoomAtSignature( 1,465, 650, 300);return false;">Zoom File</button>
   !-->
   <div id="upload" style="display:none;">
        <asp:Label ID="Label1" runat="server" Text=""
            style="font-weight: 700; color: #FF3300"></asp:Label>
        <br />
        <asp:FileUpload ID="FileUpload1" runat="server" /> &nbsp; 
       
   </div>
    
   </div>
    <div style="width:96%; float:left;">
        <radPdf:PdfWebControl id="PdfWebControl1" runat="server" height="600px" width="100%"
        ViewerZoomDefault="ZoomFitWidth100"   ViewerPageLayoutDefault="SinglePageContinuous"         
                     
                    OnClientLoad="initRadPdf();"
                     OnSaved="Saved"
                     HideEditMenu="true"
                     HideFileMenu="true"
                     HideToolsMenu="true"
                     HideSideBar="true"
                     HideBookmarks="True"
                     HideToolsTabs="True"
					  HideThumbnails="True"
					   RenderDpi="200"
                     />
    </div>
    

    </form>
</body>
</html>