using System;
using System.Diagnostics;
using RadPdf.Integration;
using RadPdf.Data.Document;
using RadPdf.Data.Document.Common;
using RadPdf.Data.Document.Objects;
using RadPdf.Data.Document.Objects.FormFields;
using RadPdf.Data.Document.Objects.Shapes;
using System.IO;
using System.Security;
using System.Net;
using System.Web;
using System.Data.OracleClient;
using System.Data;
using System.Collections;
using KtDmsLib;

partial class _Basic : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string id = "";
        string record_id = "";
        string folder_id = "";
        string doctype = "";


        //Get the new major version PDF from CRM server
        if (!IsPostBack)
        {


            byte[] pdfData = null;
            string inputFilename = Server.MapPath(@"pdfs") + "\\" + "20130831033318_105909.pdf";

            Session["saved"] = "";
            Session["id"] = "";
            Session["record_id"] = "";
            Session["folder_id"] = "";
            Session["doctype"] = "";

            if (Request.QueryString["id"] != null)
                id = Request.QueryString["id"].ToString();
            if (Request.QueryString["record_id"] != null)
                record_id = Request.QueryString["record_id"].ToString();
            if (Request.QueryString["folder_id"] != null)
                folder_id = Request.QueryString["folder_id"].ToString();
            if (Request.QueryString["doctype"] != null)
                doctype = Request.QueryString["doctype"].ToString();

            Session["id"] = id;
            Session["record_id"] = record_id;
            Session["folder_id"] = folder_id;
            Session["doctype"] = doctype;
            try
            {
                if (id == "")
                {
                    pdfData = System.IO.File.ReadAllBytes(inputFilename);
                }
                else
                {
                    try
                    {

                        WebClient wc = new WebClient();
                        wc.DownloadFile(System.Configuration.ConfigurationManager.AppSettings["CRMPDFSourceFolder"].ToString() + id + ".pdf", Server.MapPath(@"pdfs") + "\\" + id + ".pdf");

                        pdfData = System.IO.File.ReadAllBytes(Server.MapPath(@"pdfs") + "\\" + id + ".pdf");


                    }
                    catch (Exception ex)
                    {
                        Response.Write(ex.Message.ToString());
                        Response.End();
                    }
                }

            }
            catch (Exception ex)
            {

            }




            //Load PDF byte array into RAD PDF
            this.PdfWebControl1.CreateDocument(id, pdfData);
            
            PdfDocumentEditor DocumentEditor1 =
                this.PdfWebControl1.EditDocument();



        }
        else
        {

            if (Session["saved"] == "True")
            {

                if (Request.QueryString["id"] != null)
                    id = Request.QueryString["id"].ToString();
                if (Request.QueryString["folder_id"] != null)
                    folder_id = Request.QueryString["folder_id"].ToString();
                if (Request.QueryString["record_id"] != null)
                    record_id = Request.QueryString["record_id"].ToString();
                if (Request.QueryString["doctype"] != null)
                    doctype = Request.QueryString["doctype"].ToString();

                
                //Response.Redirect("./AobaAnnotationView.aspx?id=" + id + "&folder_id=" + folder_id + "&record_id=" + record_id);
                //Response.End();
            }
        }
       
    }

        protected void Saved(object sender, DocumentSavedEventArgs e)
        {
            //Check what raised the Saved event
            switch (e.SaveType)
            {
                //When we are saving or downloading
                case DocumentSaveType.Save:
                case DocumentSaveType.Download:

                    try
                    {
                        string id = "";
                        string folder_id = "";
                        string record_id = "";


                        try
                        {
                            id = Request.QueryString["id"].ToString();
                        }
                        catch (Exception ex)
                        {
                            
                        }
                        try
                        {
                            folder_id = Request.QueryString["folder_id"].ToString();
                        }
                        catch (Exception ex)
                        {

                        }
                        try
                        {
                            record_id = Request.QueryString["record_id"].ToString();
                        }
                        catch (Exception ex)
                        {

                        }


                        PdfDocumentEditor DocumentEditor1 =
                                        this.PdfWebControl1.EditDocument();
                        
                        

                        //Commit DocumentEditor changes
                        DocumentEditor1.Save();

                        //Get saved PDF
                        byte[] pdfData = e.DocumentData;
                        try
                        {
                            System.IO.File.WriteAllBytes(Server.MapPath(@"pdfs/archive/" + Session["id"] + "_signed.pdf"), pdfData);
                        }
                        catch (Exception ex)
                        {
                        
                        }
                    
                        Session["saved"] = "True";
                        int docid = uploadDMS(Session["id"].ToString(), Session["folder_id"].ToString(), Session["record_id"].ToString());
                        updateSugarDB(docid.ToString(), Session["record_id"].ToString());
                        //Response.Redirect("./AobaAnnotationList.aspx");
                        //Response.End();
                    }
                    catch (Exception ex)
                    {

                    }
                    break;
                default:

                    //Ignore all other save types (Print, etc)
                    break;


            }
        
        }

        protected KtXml BuildXML(string folderpath, string docname)
        {
            KtXml_FieldSet[] fieldsets = null;
            KtXml_Field[] ktFields = null;

            KtXml ktxml = null;
            DataSet dsFieldsets = new DataSet();
            string fieldsetName = "";
            string filename = "";
            string KtLocation = "";

            try
            {
                //dsFieldsets = (DataSet)Session["dsFieldsets"];
                // read back the xml data
                //dsFieldsets.ReadXml(ClassUtilities.getXmlDirectory() + xml_Fieldsets);

                // create an array for kt FieldSet
                fieldsets = new KtXml_FieldSet[1];

                for (int i = 0; i < 1; i++)
                {
                    // get fieldset name and field values from the panel
                    fieldsetName = "SignDocInfo";//dsFieldsets.Tables[0].Rows[i]["name"].ToString();
                    KtXml_Field ktField = new KtXml_Field("Name", docname);//this.getField(dsFieldsets.Tables[0].Rows[i]["id"].ToString());
                    ktFields = new KtXml_Field[1];
                    ktFields[0] = ktField;
                    // if there is mandatory error, a null value is expect to return 
                    if (ktFields == null) return null;

                    // create a new fieldset
                    fieldsets[i] = new KtXml_FieldSet(fieldsetName, ktFields);
                }

                // get filename
                filename = docname + ".pdf";

                // get kt location
                KtLocation = "/" + folderpath;

                // create a KtXml object
                ktxml = new KtXml(filename,
                                  filename,
                                  "admin",
                                  "Signed Doc",
                                  KtLocation,
                                  "",
                                  fieldsets);

                return ktxml;
            }
            catch (Exception ex)
            {
                throw new Exception("[BuildXML]-" + ex.Message);
            }
        }


        private int uploadDMS(string documentID, string folderID, string recordID)
        {
            int docid = -1;
            try
            {
                string err = "";
                string serverAddress = System.Configuration.ConfigurationManager.AppSettings["DMSServer"].ToString();
                KtDms dms = new KtDms(serverAddress);
                if (dms.Login("admin", "ahim1206"))
                {
                    string folderPath = dms.getFolderFullPath(Convert.ToInt32(folderID));

                    string signedfile = Server.MapPath(@"pdfs/archive/" + Session["id"] + "_signed.pdf");
                    //KtXml xml = new KtXml(documentID,documentID ,"Administrator"
                    KtXml xml = BuildXML(folderPath, documentID);

                    docid = dms.UploadDocument(signedfile, xml, true, true, false);
                    // dms.UploadDocument(
                }
                else
                {
                    err = "Incorrect username and password";
                }
                //DataSet dt = new DataSet();
                
            }
            catch (Exception ex)
            {

            }

            return docid;
            

        }

        private bool updateSugarDB(string documentID, string tableID)
        {


            //DataSet dt = new DataSet();
            bool resultb = false;
            String dbConn = System.Configuration.ConfigurationManager.AppSettings["OracleConnectionString"].ToString(); 
            
            using (OracleConnection conn = new OracleConnection(dbConn))
            {
                try
                {
                    conn.Open();
                    //using (OracleDataAdapter ada = new OracleDataAdapter(updateStr, conn))
                    //{
                    //    ada.Fill(dt);
                    //}

                    if (conn.State == ConnectionState.Open)
                    {
                        //Insert into ASANA_CRM.AS_FILES_UPLOAD_SIGN (ID,MODULE_NAME,RECORD,USER_NAME,FILE_ID_CRM_UP,FILE_ID_SIGN_IN,CRM_UPLOAD_FLAG,SIGN_IN_FLAG,DMS_FOLDER_ID,WF_FINISHED_FLAG) values ('d750f1f3-e01f-6635-7726-51c2cd4b1c91','Contacts','e52972b0-574f-fc83-e040-a8c058010c6a','frank.huang','38','64','Y ','Y ','12','N ');


                        String sqlStr = "UPDATE ASANA_CRM.AS_FILES_UPLOAD_SIGN ";
                        sqlStr += " set SIGN_IN_FLAG = :p_status, FILE_ID_SIGN_IN = :p_docid ";
                        sqlStr += " where ID = :p_id ";

                        //Command
                        OracleCommand cmdSel = new OracleCommand();
                        cmdSel.CommandText = sqlStr;
                        cmdSel.Connection = conn;

                        // Insert Parameters
                        OracleParameter pStatus = new OracleParameter();
                        pStatus.Value = "Y";
                        pStatus.ParameterName = "p_status";


                        OracleParameter pDocID = new OracleParameter();
                        pDocID.Value = documentID;
                        pDocID.ParameterName = "p_docid";

                        OracleParameter pID = new OracleParameter();
                        pID.Value = tableID;
                        pID.ParameterName = "p_id";

                        cmdSel.Parameters.Add(pID);
                        cmdSel.Parameters.Add(pDocID);
                        cmdSel.Parameters.Add(pStatus);

                        int result = cmdSel.ExecuteNonQuery();

                        if (result > 0)
                        {


                            resultb = true;
                        }
                        else 
                        {
                            resultb = false; 
                        }
         


                        //OracleDataReader reader = cmdSel.ExecuteReader();
                        //while (reader.Read())
                        //{
                        //    string test = Convert.ToString(reader["FILE_PATH"]);
                        //}

                        //return true;
                    }
                    else 
                    {
                        resultb = false; 
                    }
                }
                catch (Exception ex)
                {
                    conn.Close();
                    conn.Dispose();
                    return false; 
                }
               
                conn.Close();
                conn.Dispose();
                return resultb;
            }

        }
}
