using System;
using RadPdf.Data.Document;

partial class Custom_Interface : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack) 
        {
            string id ="";
            if (Request.QueryString["id"] != null)
                id = Request.QueryString["id"].ToString();
            //Get PDF as byte array from file (or database, browser upload, remote storage, etc)
            byte[] pdfData = System.IO.File.ReadAllBytes(Server.MapPath(@"pdfs/archive/" + Session["id"] + "_signed.pdf"));

            //Load PDF byte array into RAD PDF
            this.PdfWebControl1.CreateDocument("Document Name", pdfData,
              PdfDocumentSettings.IsReadOnlyExceptFormFields);
        }
        else
        {
            this.PdfSize.Text = "PDF size on last save: " + this.PdfWebControl1.GetPdf().Length.ToString() + " bytes";
        }
    }
}

