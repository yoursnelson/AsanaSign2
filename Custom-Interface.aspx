<%@ Page Language="C#" CodeFile="Custom-Interface.aspx.cs" Inherits="Custom_Interface" %>

<%@ Register Assembly="RadPdf" Namespace="RadPdf.Web.UI" TagPrefix="radPdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">

<meta name="viewport" content="width=device-width, user-scalable=no" />
    <title>Asana Signature</title>
    <script type="text/javascript">
        var api = null;
        
        function showViewInformation(view)
        {
            //show page information
            document.getElementById("pageInformation").innerHTML = "Page " + view.page + " of " + api.getPageCount();
        }
        
        function initRadPdf()
        {
            //get id
            var id = "<%= PdfWebControl1.ClientID%>";
            
            //get api instance
            api = new PdfWebControlApi(id);
            
            //attach listeners
            api.addEventListener(
                "viewChanged", 
                function(evt) {
                    //show new view information
                    showViewInformation(evt.view);
                }
                );
            api.addEventListener(
                "printing", 
                function(evt) {
                    //to cancel printing, we would return false or set evt.cancel = true
                    return true;
                });
           /* api.addEventListener(
                "saved",
                function(evt) {
                    if (window.confirm("Save completed. Do PostBack?")) {
                        __doPostBack(id, "");
                    }
                });*/
                
            //initially show view information
            showViewInformation(api.getView());
        }
        
        
function CloseWindow() {

            //window.open('', '_self', '');

            window.close();

        }
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div style="text-align:center;">
        <asp:Label ID="PdfSize" RunAt="server" />
    </div>
    <div style="text-align:center;">
        <!--<button onclick="if(api){api.save();}return false;">Save</button>-->
        <button onclick="if(api){api.download();}return false;">Download</button>
        <button onclick="if(api){api.print();}return false;">Print</button>
        <button onclick="CloseWindow();">Close</button>
    </div>
    <div>
        <radPdf:PdfWebControl ID="PdfWebControl1" RunAt="server" ViewerPageLayoutDefault="SinglePageContinuous" 
            Height="600px" 
            Width="100%" 
            OnClientLoad="initRadPdf();" 
            HideBookmarks="True"
            HideBottomBar="False"
            HideDownloadButton="True"
            HideSearchText="True"
            HideSideBar="True"
            HideThumbnails="False"
            HideToolsTabs="True"
            HideTopBar="True"
             RenderDpi="100"
            />
    </div>
    <!--<div style="text-align:center;">
        <button onclick="if(api){api.setView( { 'page' : api.getView().page - 1 } );}return false;">Previous Page</button>
        <span id="pageInformation" style="padding:0px 5px;"></span>
        <button onclick="if(api){api.setView( { 'page' : api.getView().page + 1 } );}return false;">Next Page</button>-->
    </div>
    </form>
</body>
</html>

