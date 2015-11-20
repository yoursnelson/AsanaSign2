using System;
using System.Diagnostics;
using RadPdf.Integration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using RadPdf.Data.Document;
using RadPdf.Data.Document.Common;
using RadPdf.Data.Document.Objects;
using RadPdf.Data.Document.Objects.FormFields;
using RadPdf.Data.Document.Objects.Shapes;
using System.IO;
using System.Security;
using System.Net;

public partial class RedirectPage : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string id = "";
        string record_id = "";
        string folder_id = "";
        string doctype = "";


        if (Request.QueryString["id"] != null)
            id = Request.QueryString["id"].ToString();
        if (Request.QueryString["record_id"] != null)
            record_id = Request.QueryString["record_id"].ToString();
        if (Request.QueryString["folder_id"] != null)
            folder_id = Request.QueryString["folder_id"].ToString();
        if (Request.QueryString["doctype"] != null)
            doctype = Request.QueryString["doctype"].ToString();



        if (id != "" && record_id != "" && folder_id != "")
        {

            Response.Redirect("./Basic.aspx?id=" + id + "&record_id=" + record_id + "&doctype=" + doctype + "&folder_id=" + folder_id);
            Response.End();
        }
        else
        {
            Response.Redirect("./Basic.aspx?id=20130831033318_105909&record_id=1&folder_id=4");

            return;
        }


    }
}
