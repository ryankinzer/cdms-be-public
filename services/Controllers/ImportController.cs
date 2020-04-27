using Newtonsoft.Json;
using services.Models;
using services.Resources;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web.Http;

namespace services.Controllers
{
    public class ImportController : CDMSController
    {
        /**
       * Handle uploaded files
       * IEnumerable<File>
       */
       // POST /api/v1/import/uploadimportfile
        [HttpPost]
        public Task<HttpResponseMessage> UploadImportFile()
        {
            logger.Debug("Inside DataActionController, UploadImportFile...");
            logger.Debug("starting to process incoming files.");

            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/uploads");
            string root = System.Configuration.ConfigurationManager.AppSettings["UploadsDirectory"] + "\\P\\";
            logger.Debug("root location = " + root);
            string rootUrl = Request.RequestUri.AbsoluteUri.Replace(Request.RequestUri.AbsolutePath, String.Empty);
            logger.Debug("root Url = " + rootUrl);

            // Make sure our folder exists
            DirectoryInfo dirInfo = new DirectoryInfo(@root);
            if (!dirInfo.Exists)
            {
                logger.Debug("Dir does not exist; will create it...");
                try
                {
                    System.IO.Directory.CreateDirectory(root);
                    logger.Debug("Created the dir...");
                }
                catch (IOException ioe)
                {
                    logger.Debug("Exception:  " + ioe.Message + ", " + ioe.InnerException);
                }
            }
            else
            {
                logger.Debug("P dir already exists...");
            }


            logger.Debug("saving files to location: " + root);
            logger.Debug(" and the root url = " + rootUrl);

            var provider = new MultipartFormDataStreamProvider(root);
            logger.Debug("provider = " + provider.ToString());

            User me = AuthorizationManager.getCurrentUser();

            var db = ServicesContext.Current;

            var task = Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            {
                logger.Debug("Inside task part...");

                if (o.IsFaulted || o.IsCanceled)
                {
                    logger.Debug("Error: " + o.Exception.Message);
                    throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.InternalServerError, o.Exception));
                }

                //Look up our project
                logger.Debug("provider.FormData = " + provider.FormData);
                Int32 ProjectId = Convert.ToInt32(provider.FormData.Get("ProjectId"));
                logger.Debug("And we think the projectid === " + ProjectId);

                Int32 DatasetId = Convert.ToInt32(provider.FormData.Get("DatasetId"));
                logger.Debug("And we think the DatasetId === " + DatasetId);

                Project project = db.Projects.Find(ProjectId);
                logger.Debug("Project.Name = " + project.Name);

                Dataset dataset = db.Datasets.Find(DatasetId);
                logger.Debug("dataset.Name = " + dataset.Name);

                if (project == null)
                    throw new Exception("Project ID not found: " + ProjectId);

                if (!project.isOwnerOrEditor(me))
                    throw new Exception("Authorization error:  The user trying to import is neither an Owner nor an Editor.");
                else
                    logger.Debug("User authorized = " + me);

                //If the project/dataset folder does not exist, create it.
                string datasetPath = root + project.Id + "\\D\\" + dataset.Id;
                //DirectoryInfo datasetDirInfo = new DirectoryInfo(@root);
                DirectoryInfo datasetDirInfo = new DirectoryInfo(datasetPath);
                if (!datasetDirInfo.Exists)
                {
                    logger.Debug("Dir does not exist; will create it...");
                    try
                    {
                        System.IO.Directory.CreateDirectory(datasetPath);
                        logger.Debug("Created the dir...");
                    }
                    catch (IOException ioe)
                    {
                        logger.Debug("Exception:  " + ioe.Message + ", " + ioe.InnerException);
                    }
                }

                var newFileName = "";

                foreach (MultipartFileData file in provider.FileData)
                {

                    logger.Debug("Filename = " + file.LocalFileName);
                    logger.Debug("Orig = " + file.Headers.ContentDisposition.FileName);
                    logger.Debug("Name? = " + file.Headers.ContentDisposition.Name);

                    var fileIndex = FileController.getFileIndex(file.Headers.ContentDisposition.Name); //"uploadedfile0" -> 0
                    var filename = file.Headers.ContentDisposition.FileName;
                    filename = filename.Replace("\"", string.Empty);

                    if (!String.IsNullOrEmpty(filename))
                    {
                        try
                        {
                            newFileName = FileController.relocateDatasetFile(
                                            file.LocalFileName,
                                            ProjectId,
                                            DatasetId,
                                            filename,
                                            true);

                            // For importing, we do not want to add the file to the Files table.
                            /*
                            File newFile = new File();
                            newFile.Title = provider.FormData.Get("Title_" + fileIndex); //"Title_1, etc.
                            newFile.Description = provider.FormData.Get("Description_" + fileIndex); //"Description_1, etc.
                            newFile.Name = info.Name;//.Headers.ContentDisposition.FileName;
                            newFile.Link = rootUrl + "/services/uploads/" + ProjectId + "/" + info.Name; //file.LocalFileName;
                            newFile.Size = (info.Length / 1024).ToString(); //file.Headers.ContentLength.ToString();
                            newFile.FileTypeId = FileType.getFileTypeFromFilename(info);
                            newFile.UserId = me.Id;
                            logger.Debug(" Adding file " + newFile.Name + " at " + newFile.Link);

                            files.Add(newFile);
                             */
                        }
                        catch (Exception e)
                        {
                            logger.Debug("Error: " + e.ToString());
                        }
                    }

                }

                logger.Debug("Done saving files.");

                var data = new ImportDataResult();
                var info = new FileInfo(newFileName);

                // Process the file and return all the data!

                /* Note:  According to Colette, if someone tries to upload a file with an odd extension (.lkg, .fld, MCR, BC1, etc.),
                 * while the extension may vary, it will almost always be a ScrewTrap-PITAGIS related file.
                 * Therefore, we are allowing a wide range of variation in the extensions.
                */
                //var regex = new Regex(@"\.(m|r|ur|mc)\d+$");
                //var regexNums = new Regex(@"\.(m|r|ur|mc|bc)\d+$");
                //var regexChars = new Regex(@"\.(m|r|ur|mc|bc)\D+$");
                var regexNums = new Regex(@"\.(m|r|ur|mc|bc|nb)\d+$");
                var regexChars = new Regex(@"\.(m|r|ur|mc|bc|nb)\D+$");
                var extension = info.Extension.ToLower();
                logger.Debug("extension = " + extension);

                if (extension == ".xls" || extension == ".xlsx")
                {
                    logger.Debug("Looks like an excel file!");
                    //var reader = new ExcelReader(newFileName);
                    //var reader = new ExcelReader2(newFileName);
                    ExcelReader2 reader;
                    //string strReaderErrorMessage = "";
                    try
                    {
                        reader = new ExcelReader2(newFileName);
                        data.columns = reader.getColumns();
                        data.rows = reader.getData();

                        if (reader.HasReadError())
                        {
                            throw new Exception("Parsing error:  " + reader.GetErrorMessage());
                        }
                    }
                    catch (Exception readerException)
                    {
                        logger.Debug("readerException = " + readerException);
                        //throw new Exception("Parsing error:  " + reader.GetErrorMessage());
                        throw new Exception("Parsing error:  " + readerException);
                    }

                    //ExcelReader doesn't support starting on a certain line for column names...  we always assume col 1
                    //if (reader.HasReadError())
                    //{
                    //    throw new Exception("Parsing error:  " + reader.GetErrorMessage());
                    //}
                    //data.columns = reader.getColumns();
                    ////data.rows = reader.getData().First().Table;
                    //data.rows = reader.getData();
                    ////reader.close(); // Unnecessary for ExcelReader2.
                }
                else if (extension == ".csv")
                {
                    logger.Debug("Looks like a csv file!");
                    var StartOnLine = Convert.ToInt32(provider.FormData.Get("StartOnLine")); //only applicable to T/CSV
                    var reader = new CSVReader(newFileName);
                    data = reader.getImportDataResult(StartOnLine); // we do it all in one.
                }
                else if (extension == ".tsv")
                {
                    logger.Debug("Looks like a tsv file!");
                    var StartOnLine = Convert.ToInt32(provider.FormData.Get("StartOnLine")); //only applicable to T/CSV
                    var reader = new TSVReader(newFileName);
                    data = reader.getImportDataResult(StartOnLine); // we do it all in one.
                }
                //else if (extension == ".lkg" || extension == ".fld" || regex.Match(extension).Success)
                else if (extension == ".lkg" || extension == ".fld" || regexNums.Match(extension).Success || regexChars.Match(extension).Success)
                {
                    logger.Debug("Looks like a PITAGIS file!");
                    var reader = new PitagisReader(newFileName);
                    data = reader.getImportDataResult(); // we do it all in one.
                }
                else
                {
                    logger.Debug("Looks like an unknown file!");
                    throw new Exception("File type not compatible.  We can do Excel (xls/xslx), CSV (csv), TSV (tsv), and PITAGIS (.lkg/.fld/.m01/.r01/.ur1/.mc1).");
                }

                var result = JsonConvert.SerializeObject(data);

                //TODO: actual error/success message handling
                //string result = "{\"message\": \"Success\"}";

                var resp = new HttpResponseMessage(HttpStatusCode.OK);
                resp.Content = new StringContent(result, System.Text.Encoding.UTF8, "text/plain");  //to stop IE from being stupid.

                return resp;

            });

            return task;

        }

    }
}
