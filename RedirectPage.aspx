<%@ Page Language="C#" AutoEventWireup="true" CodeFile="RedirectPage.aspx.cs" Inherits="RedirectPage" %>

<%@ Register Assembly="RadPdf" Namespace="RadPdf.Web.UI" TagPrefix="radPdf" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title>AHIM PDF Annotation</title>
    <link rel="stylesheet" href="style.css" type="text/css" media="screen" />  
    <script type="text/javascript">
    
    </script>
</head>
<body>
    <form id="form1" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
        </asp:ScriptManager>
        
        
    <div id="page">
        <h1>
            <a href="#" title="AHIM PDF Signature">AHIM PDF Signature</a>
        </h1>


      </div>
        

    <div id="footer">  
      <p>
        &copy; <a href="#">AHIMHK</a> | CRM: <a href="#" title="CRM">SugarCRM</a>
      </p>
    </div>
    
    </form>
</body>
</html>

